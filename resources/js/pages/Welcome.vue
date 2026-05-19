<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { computed, onMounted, reactive, ref } from 'vue';
import AppLogoIcon from '@/components/AppLogoIcon.vue';
import { IconChevronLeft, IconChevronRight } from '@tabler/icons-vue';
import { dashboard, login, register } from '@/routes';

type Swatch = { key: string; label: string; h: number; s: number; l: number };

const faqs = reactive([
    { q: "What's actually included in the subscription?", a: "Every major AI image, video and audio tool we integrate with — and our DaVinci Resolve and Adobe Premiere Pro plugins. New tools roll in as we add them; you don't get bumped to a higher tier when we do.", open: true },
    { q: "Can I use credits inside Resolve and Premiere?", a: "Yes. The plugins draw from the same credit balance as the web app. Sign in once, generate from the timeline.", open: true },
    { q: "Do unused credits roll over?", a: "Subscription credits reset each month. One-time credit packs never expire — they sit in your account until you use them.", open: true },
    { q: "Can I cancel anytime?", a: "One click in settings. You keep your remaining credits through the end of the billing cycle.", open: true },
    { q: "I'm new to AI editing — is this for me?", a: "Plain-English prompts and sensible presets. No node graphs, no model wrangling. If you can describe what you want, you can ship it.", open: true },
]);

const swatches = reactive<Swatch[]>([
    { key: 'hero-fg', label: 'Hero text', h: 0, s: 0, l: 100 },
    { key: 'hook-bg', label: 'Hook bg', h: 0, s: 0, l: 100 },
    { key: 'hook-fg', label: 'Hook heading', h: 0, s: 0, l: 9 },
    { key: 'hook-muted', label: 'Hook body', h: 0, s: 0, l: 32 },
    { key: 'ba-bg', label: 'Before/After bg', h: 40, s: 84, l: 56 },
    { key: 'ba-fg', label: 'Before/After text', h: 0, s: 0, l: 9 },
    {
        key: 'plugin-crimson-bg',
        label: 'Resolve plugin bg',
        h: 3,
        s: 64,
        l: 43,
    },
    {
        key: 'plugin-azure-bg',
        label: 'Premiere plugin bg',
        h: 218,
        s: 97,
        l: 35,
    },
    { key: 'plugin-fg', label: 'Plugins text', h: 0, s: 0, l: 100 },
    { key: 'feature-bg', label: 'Features bg', h: 0, s: 0, l: 9 },
    { key: 'feature-card', label: 'Feature card', h: 0, s: 0, l: 100 },
]);

// Horizontal masonry: two rows, same card size; bottom row shifted half
// a card so columns do not stack vertically.
// Polaroid I-Type proportions (3.5" x 4.2" outer, 3.1" square photo,
// thick bottom border). Cards share aspect ratio; row-level height
// variance produces the masonry feel without column alignment.
const featureRowHeight = 'h-96';
// Half card + half gap at h-96 and aspect 35/42: (24rem * 35/42 + 1.5rem) / 2
const featureRowStagger = 'ml-[10.75rem]';

const featureRows = [
    {
        cards: [
            {
                id: 'r1a',
                title: 'Smart trim',
                description: 'Cut dead air and keep the pace tight.',
            },
            {
                id: 'r1b',
                title: 'Scene detect',
                description: 'Split clips where the story shifts.',
            },
            {
                id: 'r1c',
                title: 'Color match',
                description: 'Balance shots without manual grading.',
            },
            {
                id: 'r1d',
                title: 'Audio sync',
                description: 'Line up dialogue and music in one pass.',
            },
            {
                id: 'r1e',
                title: 'B-roll suggest',
                description: 'Drop in cutaways that fit the beat.',
            },
            {
                id: 'r1f',
                title: 'Caption draft',
                description: 'First-pass subtitles ready to polish.',
            },
            {
                id: 'r1g',
                title: 'Export presets',
                description: 'Ship platform-ready files from one click.',
            },
        ],
    },
    {
        cards: [
            {
                id: 'r2a',
                title: 'Rough cut',
                description: 'Assembly edit from raw footage fast.',
            },
            {
                id: 'r2b',
                title: 'Beat map',
                description: 'Cuts land on the downbeat every time.',
            },
            {
                id: 'r2c',
                title: 'LUT preview',
                description: 'Try looks before you commit a grade.',
            },
            {
                id: 'r2d',
                title: 'Voice isolate',
                description: 'Pull clean VO out of noisy rooms.',
            },
            {
                id: 'r2e',
                title: 'Reframe 9:16',
                description: 'Repack horizontal edits for vertical.',
            },
            {
                id: 'r2f',
                title: 'Hook finder',
                description: 'Surface the strongest open in seconds.',
            },
            {
                id: 'r2g',
                title: 'Batch render',
                description: 'Queue exports while you keep editing.',
            },
        ],
    },
] as const;

const featuresScrollRows = ref<HTMLElement[]>([]);

function scrollRow(idx: number, dir: -1 | 1) {
    const el = featuresScrollRows.value[idx];
    if (el) el.scrollBy({ left: dir * 320, behavior: 'smooth' });
}

onMounted(() => {
    // Wait one frame so the browser has laid out the scroll content and
    // `scrollWidth` reflects the full track width including the 50vw pads.
    requestAnimationFrame(() => {
        featuresScrollRows.value.forEach(el => {
            el.scrollLeft = (el.scrollWidth - el.clientWidth) / 2;
        });
    });
});

const cssVars = computed(() => {
    const out: Record<string, string> = {};

    for (const s of swatches) {
        out[`--c-${s.key}`] = `${s.h} ${s.s}% ${s.l}%`;
    }

    return out;
});

const panelOpen = ref(false);
const copied = ref<string | null>(null);

const copy = async (s: Swatch) => {
    const val = `hsl(${s.h} ${s.s}% ${s.l}%)`;

    try {
        await navigator.clipboard.writeText(val);
        copied.value = s.key;

        setTimeout(() => (copied.value = null), 1200);
    } catch {
        /* noop */
    }
};
</script>

<template>
    <Head title="Welcome" />

    <div class="w-full overflow-x-clip" :style="cssVars">
        <section
            class="relative min-h-screen overflow-hidden text-[hsl(var(--c-hero-fg))]"
            aria-label="Hero"
        >
            <video
                class="absolute inset-0 z-0 h-full w-full object-cover"
                src="/videos/hero_clean.mp4"
                autoplay
                loop
                muted
                playsinline
                aria-hidden="true"
            ></video>
            <header class="absolute inset-x-0 top-0 z-20 p-6 lg:p-8">
                <nav
                    class="mx-auto flex max-w-6xl items-center justify-between gap-4 text-sm"
                    aria-label="Main"
                >
                    <a
                        href="#"
                        class="flex shrink-0 items-center gap-2 focus:outline-none focus-visible:ring-2 focus-visible:ring-[hsl(var(--c-hero-fg))] focus-visible:ring-offset-2 focus-visible:ring-offset-transparent"
                    >
                        <AppLogoIcon
                            class="size-6 text-[hsl(var(--c-hero-fg))]"
                            variant="lineart"
                            aria-hidden="true"
                        />
                        <span class="font-semibold tracking-tight text-[hsl(var(--c-hero-fg))]">Prompt Edit</span>
                    </a>
                    <div class="flex items-center gap-4">
                        <Link
                            v-if="$page.props.auth.user"
                            :href="dashboard()"
                            class="inline-block border border-[hsl(var(--c-hero-fg)/0.4)] px-5 py-1.5 leading-normal text-[hsl(var(--c-hero-fg))] transition-transform hover:scale-105 hover:border-[hsl(var(--c-hero-fg))]"
                        >
                            Dashboard
                        </Link>
                        <template v-else>
                            <Link
                                :href="login()"
                                class="cursor-pointer text-sm font-medium text-[hsl(var(--c-hero-fg))] transition-transform hover:scale-105"
                            >
                                Log in
                            </Link>
                            <Link
                                :href="register()"
                                class="inline-block cursor-pointer border border-[hsl(var(--c-hero-fg)/0.5)] px-5 py-1.5 text-sm font-semibold text-[hsl(var(--c-hero-fg))] transition-transform hover:scale-105 hover:border-[hsl(var(--c-hero-fg))]"
                            >
                                Register
                            </Link>
                        </template>
                    </div>
                </nav>
            </header>

            <main
                class="relative z-20 flex min-h-screen items-center justify-center px-6"
            >
                <div class="mx-auto max-w-3xl text-center">
                    <h1 class="leading-tight">
                        <span class="block text-5xl font-bold tracking-tight text-[hsl(var(--c-hero-fg))] sm:text-6xl lg:text-7xl">
                            Every AI editing tool.
                        </span>
                        <span class="font-rock-salt mt-2 block text-3xl text-[hsl(var(--c-hero-fg))] sm:text-4xl lg:text-5xl" aria-label="One subscription.">
                            One subscription.
                        </span>
                    </h1>
                    <p class="mt-8 text-base text-[hsl(var(--c-hero-fg)/0.75)] sm:text-lg">
                        Image, video and audio AI — plus DaVinci Resolve and Adobe Premiere plugins.<br class="hidden sm:block" />
                        No stacked logins, no stacked bills.
                    </p>
                    <div class="mt-8 flex flex-wrap items-center justify-center gap-3">
                        <a
                            href="#"
                            class="inline-block border border-[hsl(var(--c-hero-fg))] bg-[hsl(var(--c-hero-fg))] px-8 py-3 text-sm font-semibold text-black transition-transform hover:scale-105 hover:bg-[hsl(var(--c-hero-fg)/0.9)]"
                        >
                            Start Creating Today
                        </a>
                        <a
                            href="#"
                            class="inline-block border border-[hsl(var(--c-hero-fg)/0.5)] px-8 py-3 text-sm font-semibold text-[hsl(var(--c-hero-fg))] transition-transform hover:scale-105 hover:border-[hsl(var(--c-hero-fg))]"
                        >
                            See plans
                        </a>
                    </div>
                    <p class="mt-4 text-xs text-[hsl(var(--c-hero-fg)/0.5)]">
                        $39 / month &middot; 30-day money-back guarantee
                    </p>
                </div>
            </main>

            <div
                class="absolute bottom-6 left-1/2 z-20 -translate-x-1/2"
                aria-hidden="true"
            >
                <svg
                    class="size-6 animate-bounce text-[hsl(var(--c-hero-fg)/0.6)]"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    stroke-width="2"
                >
                    <path stroke-linecap="square" stroke-linejoin="miter" d="M19 9l-7 7-7-7" />
                </svg>
            </div>
        </section>

        <section
            id="hook-expansion"
            class="bg-[hsl(var(--c-hook-bg))] text-[hsl(var(--c-hook-fg))]"
            aria-labelledby="hook-expansion-heading"
        >
            <div class="flex flex-col lg:flex-row lg:items-stretch">
                <div
                    class="aspect-video w-full shrink-0 overflow-hidden bg-neutral-900 lg:w-[60%]"
                >
                    <video
                        class="h-full w-full object-cover"
                        src="/videos/Ai%20tool%20vs%20marketplace_eu37od3pav.mp4"
                        controls
                        playsinline
                        preload="metadata"
                        aria-label="AI tool vs marketplace"
                    >
                        Your browser does not support the video tag.
                    </video>
                </div>

                <div
                    class="flex flex-1 flex-col justify-center px-6 py-12 sm:px-10 lg:px-12 lg:py-16"
                >
                    <h2
                        id="hook-expansion-heading"
                        class="text-3xl font-semibold tracking-tight text-[hsl(var(--c-hook-fg))] sm:text-4xl"
                    >
                        One platform.<br />
                        <span class="font-rock-salt text-4xl tracking-wide sm:text-5xl">Every</span><br />
                        major AI tool.
                    </h2>
                    <p
                        class="mt-4 text-base leading-relaxed text-[hsl(var(--c-hook-muted))] sm:text-lg"
                    >
                        Stop juggling subscriptions. Prompt Edit bundles the AI tools that actually ship work — image, video, audio — under one monthly bill, with credits that work everywhere.
                    </p>
                    <p
                        class="mt-4 text-base leading-relaxed text-[hsl(var(--c-hook-muted))] sm:text-lg"
                    >
                        Plug it into the edit you're already in: generate inside <strong>DaVinci Resolve</strong> and <strong>Adobe Premiere Pro</strong> without leaving the timeline.
                    </p>
                </div>
            </div>
        </section>

        <section
            id="providers"
            class="bg-neutral-100 text-neutral-900"
            aria-labelledby="providers-heading"
        >
            <div class="mx-auto max-w-6xl px-6 py-16 sm:px-10 sm:py-20">
                <h2
                    id="providers-heading"
                    class="mb-12 text-center text-2xl font-semibold tracking-tight sm:text-3xl"
                >
                    The names you already use. <span class="font-rock-salt">ONE</span> bill.
                </h2>

                <div class="border border-neutral-300 bg-neutral-300">
                    <div class="grid grid-cols-2 gap-px sm:grid-cols-3 lg:grid-cols-5">
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">SUNO</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">HEYGEN</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">KLING</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">VEO</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">RUNWAY</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">ELEVENLABS</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">MIDJOURNEY</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">SORA</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">PIKA</div>
                        <div class="flex items-center justify-center bg-neutral-100 px-6 py-8 text-xs font-medium tracking-[0.2em] text-neutral-500">LUMA</div>
                    </div>
                </div>

                <p class="mt-6 text-center text-sm text-neutral-500">
                    + new tools roll in as we add them — no upcharge.
                </p>
            </div>
        </section>

        <section
            id="before-after"
            class="bg-[hsl(var(--c-ba-bg))] text-[hsl(var(--c-ba-fg))]"
            aria-labelledby="before-after-heading"
        >
            <div
                class="mx-auto flex min-h-[32rem] max-w-6xl flex-col items-center justify-between px-6 sm:min-h-[36rem] sm:px-10"
            >
                <figure
                    class="mx-auto flex w-full max-w-md flex-col sm:max-w-lg"
                >
                    <div
                        class="crosshatch flex aspect-[4/3] w-full items-center justify-center border border-t-0 border-[hsl(var(--c-ba-fg)/0.35)] bg-[hsl(var(--c-ba-bg))] text-sm font-medium text-[hsl(var(--c-ba-fg)/0.7)]"
                        role="img"
                        aria-label="Before PromptEdit placeholder"
                    >
                        Before Image Placeholder
                    </div>
                </figure>

                <div
                    class="h-12 w-px shrink-0 bg-[hsl(var(--c-ba-fg)/0.45)] sm:h-16"
                    aria-hidden="true"
                />

                <div
                    class="relative z-10 w-full bg-[hsl(var(--c-ba-bg))] py-8 text-center sm:py-10"
                >
                    <div
                        class="mx-auto inline-block max-w-2xl bg-[hsl(var(--c-ba-bg))] px-8 sm:px-12"
                    >
                        <h2
                            id="before-after-heading"
                            class="text-3xl font-semibold tracking-tight sm:text-4xl"
                        >
                            Same brief. <span class="font-rock-salt">One</span> workflow.
                        </h2>
                        <p
                            class="mt-4 text-base leading-relaxed text-[hsl(var(--c-ba-fg)/0.8)] sm:text-lg"
                        >
                            Trade a drawer of one-off generators for a single, consistent pipeline — one library, one credit balance, one place to look.
                        </p>
                    </div>
                </div>

                <div
                    class="flex shrink-0 flex-col items-center text-[hsl(var(--c-ba-fg)/0.45)]"
                    aria-hidden="true"
                >
                    <div class="h-12 w-px shrink-0 bg-current sm:h-16" />
                </div>

                <figure
                    class="mx-auto mb-0 flex w-full max-w-md flex-col sm:max-w-lg"
                >
                    <div
                        class="crosshatch flex aspect-[4/3] w-full items-center justify-center border border-b-0 border-[hsl(var(--c-ba-fg)/0.35)] bg-[hsl(var(--c-ba-bg))] text-sm font-medium text-[hsl(var(--c-ba-fg)/0.7)]"
                        role="img"
                        aria-label="After PromptEdit placeholder"
                    >
                        After Image Placeholder
                    </div>
                </figure>
            </div>
        </section>

        <section id="plugins" aria-labelledby="plugins-heading">
            <h2 id="plugins-heading" class="sr-only">Plugins</h2>
            <div class="flex flex-col lg:flex-row lg:items-stretch">
                <article
                    class="flex w-full flex-col bg-[hsl(var(--c-plugin-crimson-bg))] text-[hsl(var(--c-plugin-fg))] lg:w-1/2"
                    aria-labelledby="plugin-resolve-heading"
                >
                    <div class="px-6 py-12 text-center sm:px-10 lg:px-12 lg:py-16">
                        <h3
                            id="plugin-resolve-heading"
                            class="text-2xl font-semibold tracking-tight sm:text-3xl"
                        >
                            DaVinci Resolve <span class="font-rock-salt">INSIDE</span> the timeline.
                        </h3>
                        <p class="mt-4 text-base leading-relaxed text-[hsl(var(--c-plugin-fg)/0.8)] sm:text-lg">
                            Generate B-roll, voiceover, music and stills without leaving Resolve. Drag, drop, render.
                        </p>
                    </div>
                    <figure class="mt-auto w-full">
                        <div
                            class="crosshatch flex aspect-[4/3] w-full items-center justify-center border-t border-[hsl(var(--c-plugin-fg)/0.4)] bg-transparent text-sm font-medium text-[hsl(var(--c-plugin-fg)/0.75)]"
                            role="img"
                            aria-label="Da Vinci Resolve plugin placeholder"
                        >
                            Image Placeholder
                        </div>
                        <figcaption class="sr-only">
                            Da Vinci Resolve plugin preview
                        </figcaption>
                    </figure>
                </article>

                <article
                    class="flex w-full flex-col bg-[hsl(var(--c-plugin-azure-bg))] text-[hsl(var(--c-plugin-fg))] lg:w-1/2"
                    aria-labelledby="plugin-premiere-heading"
                >
                    <div class="px-6 py-12 text-center sm:px-10 lg:px-12 lg:py-16">
                        <h3
                            id="plugin-premiere-heading"
                            class="text-2xl font-semibold tracking-tight sm:text-3xl"
                        >
                            Adobe Premiere Pro, <span class="font-rock-salt">SAME</span> credits.
                        </h3>
                        <p class="mt-4 text-base leading-relaxed text-[hsl(var(--c-plugin-fg)/0.8)] sm:text-lg">
                            Native panel. Same library. The credit balance you bought in the browser works in the timeline.
                        </p>
                    </div>
                    <figure class="mt-auto w-full">
                        <div
                            class="crosshatch flex aspect-[4/3] w-full items-center justify-center border-t border-[hsl(var(--c-plugin-fg)/0.4)] bg-transparent text-sm font-medium text-[hsl(var(--c-plugin-fg)/0.75)]"
                            role="img"
                            aria-label="Adobe Premier Pro plugin placeholder"
                        >
                            Image Placeholder
                        </div>
                        <figcaption class="sr-only">
                            Adobe Premier Pro plugin preview
                        </figcaption>
                    </figure>
                </article>
            </div>
        </section>

        <section
            id="features"
            class="overflow-x-clip bg-[hsl(var(--c-feature-bg))] text-white"
            aria-labelledby="features-heading"
        >
            <div class="px-6 pt-16 sm:px-10 lg:pt-20">
                <div class="mx-auto max-w-6xl">
                    <h2
                        id="features-heading"
                        class="text-center text-3xl font-semibold tracking-tight sm:text-4xl"
                    >
                        More of the <span class="font-rock-salt">Good stuff</span>.
                    </h2>
                    <p
                        class="mx-auto mt-4 max-w-2xl text-center text-base leading-relaxed text-white/70 sm:text-lg"
                    >
                        Explore our growing collection of features made to make your creative life easier.
                        </p>
                </div>
            </div>

            <!--
                Scroller is a sibling of the padded heading wrapper so it
                spans the full viewport width without negative margins
                (which were leaking horizontal scroll onto the page).
            -->
            <div class="mt-12 flex flex-col gap-6 pb-16 lg:pb-20">
                <div
                    v-for="(row, rIdx) in featureRows"
                    :key="rIdx"
                    class="relative"
                >
                    <button
                        type="button"
                        class="absolute left-3 top-1/2 z-10 -translate-y-1/2 flex size-9 items-center justify-center rounded-full bg-neutral-800 text-white hover:bg-neutral-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-white"
                        :aria-label="`Scroll feature row ${rIdx + 1} left`"
                        @click="scrollRow(rIdx, -1)"
                    >
                        <IconChevronLeft :size="20" aria-hidden="true" />
                    </button>

                    <div
                        :ref="(el) => { if (el) featuresScrollRows[rIdx] = el as HTMLElement }"
                        class="w-full overflow-x-auto [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden"
                        :aria-label="`Feature highlights row ${rIdx + 1}, scroll horizontally`"
                        tabindex="0"
                    >
                    <ul
                        class="flex w-max gap-6 px-[50vw]"
                        :class="rIdx === 1 ? featureRowStagger : undefined"
                        role="list"
                    >
                            <li
                                v-for="card in row.cards"
                                :key="card.id"
                                class="shrink-0"
                            >
                                <!--
                                    Polaroid I-Type proportions: outer
                                    3.5" x 4.2" (aspect 35/42). Side/top
                                    borders ~5.7% of width; square photo;
                                    bottom strip holds title + copy.
                                -->
                                <figure
                                    class="flex aspect-[35/42] flex-col bg-[hsl(var(--c-feature-card))] px-[5.7%] pt-[5.7%] text-neutral-900 shadow-sm"
                                    :class="featureRowHeight"
                                >
                                    <div
                                        role="img"
                                        class="crosshatch aspect-square w-full shrink-0 bg-neutral-300 text-neutral-500"
                                        :aria-label="`${card.title} preview placeholder`"
                                    ></div>
                                    <figcaption
                                        class="flex min-h-0 flex-1 flex-col items-start justify-start gap-1 pb-2 text-left"
                                    >
                                        <h3
                                            class="relative z-10 -translate-x-[5%] -translate-y-[40%] font-rock-salt text-xl leading-tight font-bold sm:text-2xl"
                                        >
                                            {{ card.title }}
                                        </h3>
                                        <p
                                            class="font-sans text-[10px] leading-snug text-neutral-600 sm:text-xs"
                                        >
                                            {{ card.description }}
                                        </p>
                                    </figcaption>
                                </figure>
                            </li>
                    </ul>
                    </div>

                    <button
                        type="button"
                        class="absolute right-3 top-1/2 z-10 -translate-y-1/2 flex size-9 items-center justify-center rounded-full bg-neutral-800 text-white hover:bg-neutral-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-white"
                        :aria-label="`Scroll feature row ${rIdx + 1} right`"
                        @click="scrollRow(rIdx, 1)"
                    >
                        <IconChevronRight :size="20" aria-hidden="true" />
                    </button>
                </div>
            </div>
        </section>

        <section
            id="pricing"
            class="bg-white text-neutral-900"
            aria-labelledby="pricing-heading"
        >
            <div class="mx-auto max-w-6xl px-6 py-16 sm:px-10 sm:py-24">
                <h2
                    id="pricing-heading"
                    class="text-center text-3xl font-semibold tracking-tight sm:text-4xl"
                >
                    One price. <span class="font-rock-salt">EVERY</span> tool.
                </h2>
                <p class="mx-auto mt-4 max-w-xl text-center text-base leading-relaxed text-neutral-500 sm:text-lg">
                    Every AI tool, both plugins, all your credits. Cancel anytime.
                </p>

                <div class="mt-12 flex flex-col gap-4 lg:flex-row lg:items-stretch">
                    <!-- Monthly card (2/3) -->
                    <div class="relative lg:w-2/3">
                        <div class="relative h-full border border-neutral-900 bg-white p-8 [box-shadow:8px_8px_0_hsl(var(--c-plugin-azure-bg))] sm:p-10">
                            <div class="flex flex-col gap-6 sm:flex-row sm:items-start sm:justify-between">
                                <div>
                                    <p class="text-xs font-medium tracking-[0.2em] text-neutral-400">[ RECOMMENDED ]</p>
                                    <h3 class="mt-2 text-2xl font-semibold tracking-tight">
                                        Prompt Edit <span class="font-rock-salt">MONTHLY</span>
                                    </h3>
                                </div>
                                <div class="text-right shrink-0">
                                    <p class="text-5xl font-semibold tracking-tight leading-none">
                                        $39<span class="text-xl font-normal text-neutral-500">/mo</span>
                                    </p>
                                    <p class="mt-1 text-sm text-neutral-400">$49 in credits each month · ~25% free</p>
                                </div>
                            </div>

                            <ul class="mt-8 space-y-3" role="list">
                                <li class="flex items-start gap-3 text-base text-neutral-700">
                                    <span class="mt-1 shrink-0 text-neutral-900" aria-hidden="true">▪</span>
                                    Every major AI image, video and audio tool we integrate with.
                                </li>
                                <li class="flex items-start gap-3 text-base text-neutral-700">
                                    <span class="mt-1 shrink-0 text-neutral-900" aria-hidden="true">▪</span>
                                    DaVinci Resolve and Adobe Premiere Pro plugins — same credit balance, native panels.
                                </li>
                                <li class="flex items-start gap-3 text-base text-neutral-700">
                                    <span class="mt-1 shrink-0 text-neutral-900" aria-hidden="true">▪</span>
                                    New tools roll in as we add them. No upcharge, no reshuffled tiers.
                                </li>
                            </ul>

                            <a
                                href="#"
                                class="mt-8 block w-full bg-neutral-900 px-6 py-4 text-center text-base font-semibold text-white transition-transform hover:scale-105 focus:outline-none focus-visible:ring-2 focus-visible:ring-neutral-900 focus-visible:ring-offset-2"
                            >
                                Start Creating Today
                            </a>
                            <p class="mt-3 text-center text-sm text-neutral-400">
                                30-day money-back guarantee. Cancel in one click.
                            </p>
                        </div>
                    </div>

                    <!-- One-time card (1/3) -->
                    <div class="border border-neutral-200 bg-neutral-50 p-8 lg:w-1/3">
                        <p class="text-xs font-medium tracking-[0.2em] text-neutral-400">[ RATHER BUY OUTRIGHT? ]</p>
                        <h3 class="mt-2 text-xl font-semibold tracking-tight text-neutral-900">
                            One-time credit pack
                        </h3>
                        <p class="mt-3 text-base leading-relaxed text-neutral-500">
                            $110 in credits for $98. Credits never expire. Upgrade to a subscription anytime.
                        </p>
                        <a
                            href="#"
                            class="mt-6 inline-block border border-neutral-900 px-6 py-2.5 text-sm font-medium text-neutral-900 transition-transform hover:scale-105 focus:outline-none focus-visible:ring-2 focus-visible:ring-neutral-900 focus-visible:ring-offset-2"
                        >
                            Grab a pack
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Money-back guarantee -->
        <section
            class="bg-[hsl(40_84%_56%)] text-[hsl(0_0%_9%)]"
            aria-labelledby="guarantee-heading"
        >
            <div class="mx-auto max-w-3xl px-6 py-20 text-center sm:px-10 sm:py-28">
                <h2
                    id="guarantee-heading"
                    class="text-4xl font-bold leading-tight tracking-tight sm:text-5xl lg:text-6xl"
                >
                    Try everything. If it doesn't ship <span class="font-rock-salt">faster</span>, we refund <span class="font-rock-salt">every dollar</span>.
                </h2>
                <p class="mx-auto mt-6 max-w-xl text-base leading-relaxed text-[hsl(0_0%_9%/0.65)] sm:text-lg">
                    Use every tool, both plugins, all your credits. If Prompt Edit isn't faster than your current stack inside 30 days, email us. Full refund. No survey.
                </p>
                <a
                    href="#"
                    class="mt-10 inline-block bg-neutral-900 px-8 py-4 text-base font-semibold text-white transition-transform hover:scale-105 focus:outline-none focus-visible:ring-2 focus-visible:ring-neutral-900 focus-visible:ring-offset-2 focus-visible:ring-offset-[hsl(40_84%_56%)]"
                >
                    Start Creating Today — Risk Free
                </a>
            </div>
        </section>

        <!-- FAQ -->
        <section
            class="bg-[hsl(0_0%_96%)] text-neutral-900"
            aria-labelledby="faq-heading"
        >
            <div class="mx-auto max-w-3xl px-6 py-16 sm:px-10 sm:py-24">
                <div class="mb-10 text-center">
                    <p class="text-xs font-medium tracking-[0.2em] text-neutral-400">[ QUESTIONS ]</p>
                    <h2 id="faq-heading" class="mt-3 text-4xl font-bold tracking-tight sm:text-5xl">
                        Before you <span class="font-rock-salt">click</span>
                    </h2>
                </div>

                <dl>
                    <div
                        v-for="(item, i) in faqs"
                        :key="i"
                        class="border-t border-neutral-200"
                    >
                        <dt>
                            <button
                                type="button"
                                class="flex w-full items-center justify-between py-5 text-left text-base font-semibold text-neutral-900 focus:outline-none focus-visible:ring-2 focus-visible:ring-neutral-900"
                                :aria-expanded="item.open"
                                @click="item.open = !item.open"
                            >
                                <span>{{ item.q }}</span>
                                <span class="ml-6 shrink-0 text-neutral-400 text-lg leading-none" aria-hidden="true">{{ item.open ? '×' : '+' }}</span>
                            </button>
                        </dt>
                        <Transition
                            enter-active-class="transition-all duration-300 ease-out"
                            leave-active-class="transition-all duration-200 ease-in"
                            enter-from-class="opacity-0 -translate-y-1"
                            enter-to-class="opacity-100 translate-y-0"
                            leave-from-class="opacity-100 translate-y-0"
                            leave-to-class="opacity-0 -translate-y-1"
                        >
                            <dd v-if="item.open" class="pb-6 text-base leading-relaxed text-neutral-500">
                                {{ item.a }}
                            </dd>
                        </Transition>
                    </div>
                    <div class="border-t border-neutral-200"></div>
                </dl>
            </div>
        </section>

        <!-- Pre-footer CTA -->
        <section
            class="bg-neutral-950 text-white"
            aria-labelledby="prefooter-heading"
        >
            <div class="mx-auto max-w-3xl px-6 py-24 text-center sm:px-10 sm:py-32">
                <h2
                    id="prefooter-heading"
                    class="text-5xl font-bold leading-tight tracking-tight sm:text-6xl lg:text-7xl"
                >
                    Stop stacking subs.<br>
                    <span class="font-rock-salt">Start</span> editing.
                </h2>
                <a
                    href="#"
                    class="mt-10 inline-block bg-white px-10 py-4 text-base font-semibold text-neutral-900 transition-transform hover:scale-105 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-offset-2 focus-visible:ring-offset-neutral-950"
                >
                    Start Creating Today
                </a>
                <p class="mt-4 text-sm text-neutral-500">$39 / month · 30-day money-back · cancel anytime</p>
            </div>
        </section>

        <!-- Footer -->
        <footer class="border-t border-neutral-800 bg-neutral-950">
            <div class="mx-auto flex max-w-6xl items-center justify-between px-6 py-5 sm:px-10">
                <div class="flex items-center gap-2 text-neutral-400">
                    <AppLogoIcon class="size-5 shrink-0" variant="lineart" aria-hidden="true" />
                    <span class="font-semibold tracking-tight text-sm">Prompt Edit</span>
                    <span class="text-neutral-600" aria-hidden="true">·</span>
                    <span class="text-sm text-neutral-600">© 2026</span>
                </div>
            </div>
        </footer>

        <!-- Tweaks panel -->
        <div
            class="pointer-events-none fixed inset-x-0 bottom-0 z-50 flex justify-end p-4 sm:inset-x-auto sm:right-4 sm:bottom-4"
            aria-live="polite"
        >
            <button
                v-if="!panelOpen"
                type="button"
                @click="panelOpen = true"
                class="pointer-events-auto bg-neutral-900 px-4 py-2 text-xs font-medium text-white shadow-lg ring-1 ring-white/10 hover:bg-neutral-800 focus:outline-none focus-visible:ring-2 focus-visible:ring-white"
                aria-label="Open color tweaks panel"
            >
                Tweaks
            </button>

            <section
                v-else
                role="dialog"
                aria-label="Color tweaks"
                class="pointer-events-auto w-full max-w-sm border border-white/10 bg-neutral-900/95 p-4 text-xs text-white shadow-2xl backdrop-blur sm:w-80"
            >
                <header class="mb-3 flex items-center justify-between gap-2">
                    <h3 class="font-medium tracking-wide uppercase">Tweaks</h3>
                    <button
                        type="button"
                        @click="panelOpen = false"
                        class="p-1 text-white/70 hover:bg-white/10 hover:text-white focus:outline-none focus-visible:ring-2 focus-visible:ring-white"
                        aria-label="Close tweaks panel"
                    >
                        <svg
                            class="size-4"
                            viewBox="0 0 20 20"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            aria-hidden="true"
                        >
                            <path
                                d="M5 5l10 10M15 5L5 15"
                                stroke-linecap="round"
                            />
                        </svg>
                    </button>
                </header>

                <ul class="max-h-[60vh] space-y-3 overflow-y-auto pr-1">
                    <li
                        v-for="s in swatches"
                        :key="s.key"
                        class="bg-white/5 p-2"
                    >
                        <div
                            class="mb-1.5 flex items-center justify-between gap-2"
                        >
                            <div class="flex items-center gap-2">
                                <span
                                    class="inline-block size-4 border border-white/20"
                                    :style="{
                                        backgroundColor: `hsl(${s.h} ${s.s}% ${s.l}%)`,
                                    }"
                                    aria-hidden="true"
                                ></span>
                                <span class="font-medium">{{ s.label }}</span>
                            </div>
                            <button
                                type="button"
                                @click="copy(s)"
                                class="bg-white/10 px-2 py-0.5 font-mono text-[10px] hover:bg-white/20 focus:outline-none focus-visible:ring-2 focus-visible:ring-white"
                                :aria-label="`Copy HSL value for ${s.label}`"
                            >
                                {{ copied === s.key ? 'copied' : 'copy' }}
                            </button>
                        </div>

                        <p
                            class="mb-1.5 font-mono text-[11px] text-white/70 select-all"
                        >
                            hsl({{ s.h }} {{ s.s }}% {{ s.l }}%)
                        </p>

                        <div
                            class="grid grid-cols-[1.25rem_1fr_2.5rem] items-center gap-x-2 gap-y-1"
                        >
                            <label :for="`${s.key}-h`" class="text-white/60"
                                >H</label
                            >
                            <input
                                :id="`${s.key}-h`"
                                type="range"
                                min="0"
                                max="360"
                                v-model.number="s.h"
                                class="w-full accent-white"
                            />
                            <span class="text-right font-mono">{{ s.h }}</span>

                            <label :for="`${s.key}-s`" class="text-white/60"
                                >S</label
                            >
                            <input
                                :id="`${s.key}-s`"
                                type="range"
                                min="0"
                                max="100"
                                v-model.number="s.s"
                                class="w-full accent-white"
                            />
                            <span class="text-right font-mono">{{ s.s }}%</span>

                            <label :for="`${s.key}-l`" class="text-white/60"
                                >L</label
                            >
                            <input
                                :id="`${s.key}-l`"
                                type="range"
                                min="0"
                                max="100"
                                v-model.number="s.l"
                                class="w-full accent-white"
                            />
                            <span class="text-right font-mono">{{ s.l }}%</span>
                        </div>
                    </li>
                </ul>
            </section>
        </div>
    </div>
</template>
