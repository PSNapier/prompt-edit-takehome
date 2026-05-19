<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import AppLogoIcon from '@/components/AppLogoIcon.vue';
import { dashboard, login, register } from '@/routes';
</script>

<template>
    <Head title="Welcome" />

    <div class="w-full">
        <section
            class="relative min-h-screen overflow-hidden text-white"
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
                        class="shrink-0 rounded-sm focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-offset-2 focus-visible:ring-offset-transparent"
                    >
                        <AppLogoIcon
                            class="size-9 text-white"
                            variant="lineart"
                            aria-hidden="true"
                        />
                        <span class="sr-only">Prompt Edit</span>
                    </a>
                    <div class="flex items-center gap-4">
                        <Link
                            v-if="$page.props.auth.user"
                            :href="dashboard()"
                            class="inline-block rounded-sm border border-white/40 px-5 py-1.5 leading-normal text-white hover:border-white"
                        >
                            Dashboard
                        </Link>
                        <template v-else>
                            <Link
                                :href="login()"
                                class="inline-block rounded-sm border border-transparent px-5 py-1.5 leading-normal text-white hover:border-white/40"
                            >
                                Log in
                            </Link>
                            <Link
                                :href="register()"
                                class="inline-block rounded-sm border border-white/40 px-5 py-1.5 leading-normal text-white hover:border-white"
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
                        class="font-serif text-4xl font-semibold tracking-tight sm:text-5xl lg:text-6xl"
                    >
                        Welcome
                    </h1>
                    <p class="mt-6 text-base text-white/80 sm:text-lg">
                        A simple, focused hero section to set the stage.
                    </p>
                    <div
                        class="mt-8 flex flex-wrap items-center justify-center gap-3"
                    >
                        <a
                            href="#"
                            class="inline-block rounded-sm border border-white bg-white px-6 py-2 text-sm font-medium text-black hover:bg-white/90"
                        >
                            Get started
                        </a>
                        <a
                            href="#"
                            class="inline-block rounded-sm border border-white/40 px-6 py-2 text-sm font-medium text-white hover:border-white"
                        >
                            Learn more
                        </a>
                    </div>
                </div>
            </main>
        </section>

        <section
            id="hook-expansion"
            class="bg-white text-neutral-900"
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
                        class="font-serif text-3xl font-semibold tracking-tight text-neutral-900 sm:text-4xl"
                    >
                        The Best Video AI Tools, All In One Place
                    </h2>
                    <p
                        class="mt-4 text-base leading-relaxed text-neutral-600 sm:text-lg"
                    >
                        Placeholder copy for your product story. Swap this
                        with benefits, social proof, or a short pitch that
                        supports the hero above.
                    </p>
                    <p
                        class="mt-4 text-base leading-relaxed text-neutral-600 sm:text-lg"
                    >
                        A second paragraph gives room for detail without
                        crowding the layout. Pair with a real embed or
                        hosted video on the left.
                    </p>
                </div>
            </div>
        </section>
    </div>
</template>
