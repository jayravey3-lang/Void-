-- VOID Supabase schema. Run in the Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  bio text not null default '',
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.library_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  item_key text not null,
  title text not null,
  description text not null default '',
  category text not null default 'General',
  saved_at timestamptz not null default now(),
  unique(user_id, item_key)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references auth.users(id) on delete cascade,
  recipient_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 5000),
  created_at timestamptz not null default now(),
  read_at timestamptz,
  check (sender_id <> recipient_id)
);

create table if not exists public.feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  category text not null default 'Suggestion' check (char_length(category) <= 40),
  subject text not null check (char_length(subject) between 1 and 120),
  details text not null check (char_length(details) between 1 and 5000),
  status text not null default 'new' check (status in ('new','in_review','resolved','closed')),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.library_items enable row level security;
alter table public.messages enable row level security;
alter table public.feedback enable row level security;

create policy "Profiles readable by signed-in users" on public.profiles for select to authenticated using (true);
create policy "Users create own profile" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "Users update own profile" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "Users manage own library" on public.library_items for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Participants read messages" on public.messages for select to authenticated using (auth.uid() = sender_id or auth.uid() = recipient_id);
create policy "Sender creates own messages" on public.messages for insert to authenticated with check (auth.uid() = sender_id);
create policy "Recipient marks messages read" on public.messages for update to authenticated using (auth.uid() = recipient_id) with check (auth.uid() = recipient_id);

create policy "Signed-in users submit feedback" on public.feedback for insert to authenticated with check (user_id = auth.uid());
-- Intentionally no public SELECT/UPDATE policy on feedback: use a trusted admin dashboard/service-role backend.
