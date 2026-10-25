-- VOID security and social foundation migration.
-- Review and run after supabase/schema.sql in the Supabase SQL Editor.

alter table public.profiles
  add column if not exists username text,
  add column if not exists profile_visibility text not null default 'private'
    check (profile_visibility in ('private','public'));

create unique index if not exists profiles_username_lower_unique
  on public.profiles (lower(username))
  where username is not null;

-- Replace the original broad profile-read policy with visibility-aware access.
drop policy if exists "Profiles readable by signed-in users" on public.profiles;
drop policy if exists "Profiles visible by privacy setting" on public.profiles;
create policy "Profiles visible by privacy setting" on public.profiles
  for select to authenticated
  using (auth.uid() = id or profile_visibility = 'public');

create table if not exists public.user_blocks (
  blocker_id uuid not null references auth.users(id) on delete cascade,
  blocked_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);
alter table public.user_blocks enable row level security;
drop policy if exists "Users view own blocks" on public.user_blocks;
create policy "Users view own blocks" on public.user_blocks
  for select to authenticated using (auth.uid() = blocker_id);
drop policy if exists "Users manage own blocks" on public.user_blocks;
create policy "Users manage own blocks" on public.user_blocks
  for all to authenticated
  using (auth.uid() = blocker_id)
  with check (auth.uid() = blocker_id);

-- Tighten message sending so a user cannot send to themselves or someone
-- who has blocked them, and users cannot message someone they have blocked.
drop policy if exists "Sender creates own messages" on public.messages;
create policy "Sender creates own messages" on public.messages
  for insert to authenticated
  with check (
    auth.uid() = sender_id
    and sender_id <> recipient_id
    and not exists (
      select 1 from public.user_blocks b
      where (b.blocker_id = recipient_id and b.blocked_id = sender_id)
         or (b.blocker_id = sender_id and b.blocked_id = recipient_id)
    )
  );

create table if not exists public.user_reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references auth.users(id) on delete cascade,
  reported_user_id uuid references auth.users(id) on delete set null,
  message_id uuid references public.messages(id) on delete set null,
  category text not null check (char_length(category) between 1 and 50),
  details text not null default '' check (char_length(details) <= 3000),
  status text not null default 'new' check (status in ('new','in_review','resolved','dismissed')),
  created_at timestamptz not null default now(),
  check (reported_user_id is not null or message_id is not null)
);
alter table public.user_reports enable row level security;
drop policy if exists "Users submit reports for themselves" on public.user_reports;
create policy "Users submit reports for themselves" on public.user_reports
  for insert to authenticated
  with check (auth.uid() = reporter_id and reporter_id is distinct from reported_user_id);
drop policy if exists "Users read own submitted reports" on public.user_reports;
create policy "Users read own submitted reports" on public.user_reports
  for select to authenticated using (auth.uid() = reporter_id);

-- No client-side read/update policy is provided for reports. Moderation should
-- use a separately authenticated, role-restricted admin service.
