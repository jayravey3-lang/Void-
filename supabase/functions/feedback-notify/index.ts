// Optional email notification function. Configure RESEND_API_KEY and FEEDBACK_TO secrets.
// Call only from a trusted server workflow after inserting feedback with the authenticated user context.
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") return Response.json({ error: "POST required" }, { status: 405 });
  const apiKey = Deno.env.get("RESEND_API_KEY");
  const to = Deno.env.get("FEEDBACK_TO") || "voidsearch0@gmail.com";
  if (!apiKey) return Response.json({ error: "Email provider is not configured." }, { status: 503 });
  const { category, subject, details, feedbackId } = await req.json();
  if (![category, subject, details].every(v => typeof v === "string") || subject.length > 120 || details.length > 5000) {
    return Response.json({ error: "Invalid feedback payload." }, { status: 400 });
  }
  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: { "Authorization": `Bearer ${apiKey}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      from: "VOID Feedback <onboarding@resend.dev>",
      to: [to],
      subject: `[VOID Feedback] ${subject}`,
      text: `Category: ${category}\nFeedback ID: ${feedbackId || "not supplied"}\n\n${details}`,
    }),
  });
  if (!response.ok) return Response.json({ error: "Email provider rejected the request." }, { status: 502 });
  return Response.json({ sent: true });
});
