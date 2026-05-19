Here's a thorough, no-opinion audit broken down by category.

---

## Page Structure & Layout

| Section                      | What's There                                                                                                                          |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Nav                          | Logo + "Tutorials" link + "Login" link                                                                                                |
| Hero                         | PromptEdit logo image + a mobile mockup image + embedded Wistia video + CTA button                                                    |
| Pre-offer copy               | Long-form conversational text block selling the "why"                                                                                 |
| Product intro                | Headline + "Trusted By" image + Before/After images                                                                                   |
| Tool categories              | AI Image, AI Video, AI Audio, AI Editing Plugins — each with a category logo image + sub-sections with embedded Wistia videos         |
| Pricing                      | Two side-by-side offers: one-time $98 credit pack vs. $39/month subscription                                                          |
| Templates Library            | Extended section with LUTs, SFX, Text Animations, Overlays, Backgrounds — each with video demos, grid screenshots, and recurring CTAs |
| Testimonials                 | 3 testimonials with photos and names                                                                                                  |
| "Is this for you?" checklist | 5 bullet points                                                                                                                       |
| FAQ                          | 8 questions with accordion-style answers                                                                                              |
| Money-back guarantee         | Appears twice (once mid-page, once near footer)                                                                                       |
| Footer                       | Legal disclaimer, copyright, terms/privacy/earnings links, Facebook disclaimer                                                        |

---

## Copy Audit

### Headline Inventory

| Location                 | Headline / Subhead                                                              |
| ------------------------ | ------------------------------------------------------------------------------- |
| Page title tag           | "Prompt Edit \| Exclusive Offer"                                                |
| Meta description         | "the most affordable AI marketplace on earth"                                   |
| Main H1 equivalent       | "Prompt Edit — The most affordable AI marketplace featuring the best AI tools." |
| Templates section        | "Here's a More Detailed Look at our Content Creator Templates Library"          |
| SFX section              | "Hear the Difference Sound Makes"                                               |
| Sound effects H1         | "Access 60,000+ Sound Effects Today!"                                           |
| Listen CTA section       | "Listen to Some of Our Sounds"                                                  |
| Subscription fit section | "A Subscription to PromptEdit.com...is for you if..."                           |
| Unlimited usage section  | "UNLIMITED Downloads & UNLIMITED Usage"                                         |
| FAQ section              | "Commonly Asked Questions"                                                      |
| Guarantee section        | "Backed by our 100% Money Back Satisfaction Guarantee"                          |
| Footer popup/sticky      | "Join Our Free Trial"                                                           |

### Copy Tone & Style

- Conversational, first-person plural ("We put together...")
- Heavy use of rhetorical questions to drive reader through the narrative
- Sentence fragments used intentionally for pacing (e.g. "No subscription required. You get to try the tools. Use the tools.")
- Analogy-driven: "grocery store for AI", "like buying gas for a car"
- Urgency language present: "exclusive," "one-time offer," "once in a lifetime opportunity"

### Copy Inconsistencies / Flags

| Issue                                            | Detail                                                                                                                                                                                                                   |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Brand name inconsistency                         | Page uses "Prompt Edit," "PromptEdit," and "PromptEdit.com" interchangeably                                                                                                                                              |
| Footer popup copy                                | "Join Our Free Trial" — no free trial is mentioned anywhere else on the page                                                                                                                                             |
| Disclaimer references wrong product              | Footer disclaimer references "14 Day Filmmaker" course, not the AI Creator Course mentioned in the page body                                                                                                             |
| Copyright year mismatch                          | Body footer says "© 2025 Paul Xavier International LLC" but Kajabi footer says "© 2026 Kajabi"                                                                                                                           |
| Pricing copy contradiction                       | "Save Everything" plan says "$49 Worth of AI Credits every month" in one line, then says "lifetime 20% boost on monthly credits" — the math/framing isn't connected                                                      |
| Refund policy stated twice, slightly differently | Mid-page version says "within 30 days...full refund on unused credits." FAQ/guarantee section says "AI credits that have already been spent are non-refundable" — consistent in meaning but worded differently each time |
| "Nano Banana Pro" listed among tools             | Listed alongside recognizable brands (Grok, Veo, Heygen, Eleven Labs, Suno) — appears to be a lesser-known or placeholder name                                                                                           |

---

## UI / Visual Audit

### Images

- Multiple images are used purely as styled text blocks (e.g. "Before PromptEdit" / "After PromptEdit" are images, not live text)
- Tool logo strip ("Trusted By") is an image with no alt text context
- Grid screenshots of templates (LUTs, Overlays, etc.) appear to have separate mobile and desktop versions loaded via separate `<img>` tags
- All images hosted on Kajabi CDN

### Video Embeds

- 20+ Wistia video embeds throughout the page
- Used heavily in the tool category sections as demos (AI Clones, Social Media Posts, Graphic Design, etc.)
- Audio tool section has a "Click to preview!" label above 5 separate audio embeds
- Two SFX comparison videos use the "VS" framing (muted vs. with sound)
- Some video embeds appear as raw iframe URLs in the raw content, suggesting possible rendering issues depending on browser/environment

### CTAs

| CTA Text                                          | Destination                                             |
| ------------------------------------------------- | ------------------------------------------------------- |
| "Click To Get Started Today!"                     | Anchor link to #section-1612824161864 (pricing section) |
| "Claim Deal" (one-time $98)                       | Empty `<>` href — no destination                        |
| "Claim Deal" ($39/month)                          | Links to https://promptedit.com                         |
| "Click to Get Started Today!" (repeated ~6 times) | Anchor link to pricing section                          |

### Navigation

- Minimal nav: just Logo, Tutorials, Login
- No sticky nav
- No breadcrumbs

### Trust Elements

- "Trusted By" logo strip image
- 3 named testimonials with photos
- Money-back guarantee badge (appears twice)
- Payment methods image shown near pricing

### Meta / SEO Flags

- Page is set to `noindex, nofollow` — intentionally hidden from search engines (consistent with it being a funnel/upsell page)
- OG image, Twitter card, and description are all set correctly
- Page title "Prompt Edit | Exclusive Offer" is appropriate for a post-purchase upsell context

---

## Pricing Section Audit

| Plan                 | Price  | What You Get                                                                                                                                                                                            |
| -------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| One-Time Credit Pack | $98    | $110 worth of AI credits (10% savings)                                                                                                                                                                  |
| Monthly Subscription | $39/mo | $49 worth of credits/month + 20% lifetime boost on monthly credits + 10% off additional credit purchases + Content Creator Templates Library access + faster speeds + multiple simultaneous generations |

- The one-time plan's "Claim Deal" CTA has a broken/empty link (`<>`)
- The subscription plan "Claim Deal" links to `promptedit.com`
- No annual plan option presented
- No price comparison table between this offer and what tools cost individually

---

## FAQ Audit

| Question                                           | Answer Quality                                      |
| -------------------------------------------------- | --------------------------------------------------- |
| What is PromptEdit.com?                            | Detailed, uses the grocery store analogy            |
| Can I use for commercial projects?                 | Clear yes, covers licensing                         |
| Quality difference vs. original tools?             | Direct no-difference answer                         |
| What is Content Creator Templates?                 | Lists assets included                               |
| Download limits?                                   | Answers clearly, references Terms of Service        |
| Template compatibility?                            | Yes with a caveat about platform-specific templates |
| Can I cancel?                                      | Yes, references email and in-app cancellation       |
| What happens to downloaded templates after cancel? | Distinguishes between already-used vs. future use   |

One notable gap: no FAQ addressing what happens to purchased AI credits if you cancel the subscription.
