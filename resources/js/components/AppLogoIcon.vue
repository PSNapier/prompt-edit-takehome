<script setup lang="ts">
import { IconBoltFilled } from '@tabler/icons-vue';
import type { HTMLAttributes } from 'vue';
import { computed } from 'vue';

defineOptions({
    inheritAttrs: false,
});

type Props = {
    className?: HTMLAttributes['class'];
    /** Brand amber, mono white, or currentColor lineart */
    variant?: 'brand' | 'mono' | 'lineart';
};

const props = withDefaults(defineProps<Props>(), {
    variant: 'brand',
});

const iconColor = computed((): string => {
    if (props.variant === 'mono') {
        return 'hsl(0 0% 100%)';
    }

    if (props.variant === 'lineart') {
        return 'currentColor';
    }

    return 'hsl(40 78% 46%)';
});
</script>

<template>
    <IconBoltFilled
        :color="iconColor"
        :class="[className, variant === 'mono' ? 'opacity-90' : undefined]"
        v-bind="$attrs"
    />
</template>
