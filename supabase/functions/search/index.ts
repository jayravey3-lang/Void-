// Supabase Edge Function scaffold. Set SEARCH_API_URL and SEARCH_API_KEY as function secrets.
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return Response.json({ error: "POST required" }, { status: 405, headers: cors });
  const url = Deno.env.get("SEARCH_API_URL");
  const key = Deno.env.get("SEARCH_API_KEY");
  if (!url || !key) return Response.json({ error: "Search provider is not configured yet." }, { status: 503, headers: cors });
  try {
    const { query } = await req.json();
    if (typeof query !== "string" || query.trim().length < 1 || query.length > 200) {
      return Response.json({ error: "Enter a search query under 200 characters." }, { status: 400, headers: cors });
    }
    const upstream = await fetch(url, {
      method: "POST",
      headers: { "Authorization": `Bearer ${key}`, "Content-Type": "application/json" },
      body: JSON.stringify({ query: query.trim() }),
    });
    const body = await upstream.text();
    return new Response(body, { status: upstream.status, headers: { ...cors, "Content-Type": upstream.headers.get("content-type") || "application/json" } });
  } catch {
    return Response.json({ error: "Search request failed." }, { status: 500, headers: cors });
  }
});
