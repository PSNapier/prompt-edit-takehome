<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { computed, onMounted, reactive, ref } from 'vue';
import AppLogoIcon from '@/components/AppLogoIcon.vue';
import { dashboard, login, register } from '@/routes';

type Swatch = { key: string; label: string; h: number; s: number; l: number };

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

const featuresScroll = ref<HTMLElement | null>(null);

onMounted(() => {
    // Wait one frame so the browser has laid out the scroll content and
    // `scrollWidth` reflects the full track width including the 50vw pads.
    requestAnimationFrame(() => {
        const el = featuresScroll.value;

        if (!el) {
            return;
        }

        el.scrollLeft = (el.scrollWidth - el.clientWidth) / 2;
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
                        class="shrink-0 focus:outline-none focus-visible:ring-2 focus-visible:ring-[hsl(var(--c-hero-fg))] focus-visible:ring-offset-2 focus-visible:ring-offset-transparent"
                    >
                        <AppLogoIcon
                            class="size-9 text-[hsl(var(--c-hero-fg))]"
                            variant="lineart"
                            aria-hidden="true"
                        />
                        <span class="sr-only">Prompt Edit</span>
                    </a>
                    <div class="flex items-center gap-4">
                        <Link
                            v-if="$page.props.auth.user"
                            :href="dashboard()"
                            class="inline-block border border-[hsl(var(--c-hero-fg)/0.4)] px-5 py-1.5 leading-normal text-[hsl(var(--c-hero-fg))] hover:border-[hsl(var(--c-hero-fg))]"
                        >
                            Dashboard
                        </Link>
                        <template v-else>
                            <Link
                                :href="login()"
                                class="inline-block border border-transparent px-5 py-1.5 leading-normal text-[hsl(var(--c-hero-fg))] hover:border-[hsl(var(--c-hero-fg)/0.4)]"
                            >
                                Log in
                            </Link>
                            <Link
                                :href="register()"
                                class="inline-block border border-[hsl(var(--c-hero-fg)/0.4)] px-5 py-1.5 leading-normal text-[hsl(var(--c-hero-fg))] hover:border-[hsl(var(--c-hero-fg))]"
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
                    <h1
                        class="text-4xl font-semibold tracking-tight sm:text-5xl lg:text-6xl"
                    >
                        Welcome
                    </h1>
                    <p
                        class="mt-6 text-base text-[hsl(var(--c-hero-fg)/0.8)] sm:text-lg"
                    >
                        A simple, focused hero section to set the stage.
                    </p>
                    <div
                        class="mt-8 flex flex-wrap items-center justify-center gap-3"
                    >
                        <a
                            href="#"
                            class="inline-block border border-[hsl(var(--c-hero-fg))] bg-[hsl(var(--c-hero-fg))] px-6 py-2 text-sm font-medium text-black hover:bg-[hsl(var(--c-hero-fg)/0.9)]"
                        >
                            Get started
                        </a>
                        <a
                            href="#"
                            class="inline-block border border-[hsl(var(--c-hero-fg)/0.4)] px-6 py-2 text-sm font-medium text-[hsl(var(--c-hero-fg))] hover:border-[hsl(var(--c-hero-fg))]"
                        >
                            Learn more
                        </a>
                    </div>
                </div>
            </main>
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
                        The Best Video AI Tools, All In One Place
                    </h2>
                    <p
                        class="mt-4 text-base leading-relaxed text-[hsl(var(--c-hook-muted))] sm:text-lg"
                    >
                        Placeholder copy for your product story. Swap this with
                        benefits, social proof, or a short pitch that supports
                        the hero above.
                    </p>
                    <p
                        class="mt-4 text-base leading-relaxed text-[hsl(var(--c-hook-muted))] sm:text-lg"
                    >
                        A second paragraph gives room for detail without
                        crowding the layout. Pair with a real embed or hosted
                        video on the left.
                    </p>
                </div>
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
                        class="flex aspect-[4/3] w-full items-center justify-center border border-t-0 border-[hsl(var(--c-ba-fg)/0.35)] bg-[hsl(var(--c-ba-bg))] text-sm font-medium text-[hsl(var(--c-ba-fg)/0.7)]"
                        role="img"
                        aria-label="Before PromptEdit placeholder"
                    >
                        Before
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
                            See the difference
                        </h2>
                        <p
                            class="mt-4 text-base leading-relaxed text-[hsl(var(--c-ba-fg)/0.8)] sm:text-lg"
                        >
                            Placeholder for before-and-after creative output.
                            Swap with real comparison assets from your funnel.
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
                        class="flex aspect-[4/3] w-full items-center justify-center border border-b-0 border-[hsl(var(--c-ba-fg)/0.35)] bg-[hsl(var(--c-ba-bg))] text-sm font-medium text-[hsl(var(--c-ba-fg)/0.7)]"
                        role="img"
                        aria-label="After PromptEdit placeholder"
                    >
                        After
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
                    <h3
                        id="plugin-resolve-heading"
                        class="px-6 py-12 text-center text-2xl font-semibold tracking-tight sm:px-10 sm:text-3xl lg:px-12 lg:py-16"
                    >
                        Da Vinci Resolve Plugin
                    </h3>
                    <figure class="mt-auto w-full">
                        <div
                            class="flex aspect-[4/3] w-full items-center justify-center border-t border-[hsl(var(--c-plugin-fg)/0.4)] bg-transparent text-sm font-medium text-[hsl(var(--c-plugin-fg)/0.75)]"
                            role="img"
                            aria-label="Da Vinci Resolve plugin placeholder"
                        >
                            Placeholder
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
                    <h3
                        id="plugin-premiere-heading"
                        class="px-6 py-12 text-center text-2xl font-semibold tracking-tight sm:px-10 sm:text-3xl lg:px-12 lg:py-16"
                    >
                        Adobe Premier Pro Plugin
                    </h3>
                    <figure class="mt-auto w-full">
                        <div
                            class="flex aspect-[4/3] w-full items-center justify-center border-t border-[hsl(var(--c-plugin-fg)/0.4)] bg-transparent text-sm font-medium text-[hsl(var(--c-plugin-fg)/0.75)]"
                            role="img"
                            aria-label="Adobe Premier Pro plugin placeholder"
                        >
                            Placeholder
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
                        Features
                    </h2>
                    <p
                        class="mx-auto mt-4 max-w-2xl text-center text-base leading-relaxed text-white/70 sm:text-lg"
                    >
                        Drag or scroll sideways to explore.
                    </p>
                </div>
            </div>

            <!--
                Scroller is a sibling of the padded heading wrapper so it
                spans the full viewport width without negative margins
                (which were leaking horizontal scroll onto the page).
            -->
            <div class="pb-16 lg:pb-20">
                <div
                    ref="featuresScroll"
                    class="mt-12 w-full [scrollbar-width:none] overflow-x-auto [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden"
                    aria-label="Feature highlights, scroll horizontally"
                    tabindex="0"
                >
                    <div class="flex w-max flex-col gap-6 px-[50vw]">
                        <ul
                            v-for="(row, rIdx) in featureRows"
                            :key="rIdx"
                            class="flex gap-6"
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
                                        class="aspect-square w-full shrink-0 bg-neutral-300"
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
                </div>
            </div>
        </section>

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
