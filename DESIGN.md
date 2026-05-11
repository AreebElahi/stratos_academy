# Design System Document

## 1. Overview & Creative North Star: "The Academic Pulse"

This design system is engineered to transform the student experience from a chaotic checklist into a high-performance workspace. Moving beyond the "standard dark mode" template, this system adopts **"The Academic Pulse"** as its Creative North Star. 

The visual language balances the intellectual authority of a premium editorial publication with the sleek, kinetic energy of modern fintech. By utilizing deep navy voids (`surface`), vibrant cobalt accents (`primary`), and intentional asymmetry, we move away from rigid, boxy layouts toward a fluid, "glass-on-glass" layering technique. The experience should feel organized, professional, and sophisticated—challenging the user to perform at their highest level.

---

## 2. Colors: Tonal Depth & The "No-Line" Philosophy

The palette is rooted in deep obsidians and electric blues, designed to reduce eye strain while maintaining a high-tech "glow."

### Surface Hierarchy & Nesting
Instead of a flat canvas, treat the UI as a series of physical layers.
- **Base Level:** `background` (#0c0e12) – The infinite canvas.
- **Section Level:** `surface_container_low` (#111417) – Used for large organizational blocks.
- **Interactive Level:** `surface_container_highest` (#22262b) – For the most critical interactive cards.

### The "No-Line" Rule
Prohibit the use of 1px solid borders for sectioning. Boundaries must be defined solely through background color shifts. For example, a `surface_container_high` module sitting on a `surface` background creates a clear, sophisticated boundary without the visual "noise" of a stroke.

### The "Glass & Signature" Rule
- **Glassmorphism:** For floating headers or navigation bars, use `surface_bright` at 60% opacity with a 20px backdrop-blur. 
- **Signature Textures:** Main CTAs should not be flat. Use a subtle linear gradient from `primary` (#9ba8ff) to `primary_dim` (#4963ff) at a 135-degree angle to provide a "pulsing" depth that suggests interactivity.

---

## 3. Typography: The Editorial Authority

This system pairs **Space Grotesk** (Display/Headline) with **Manrope** (Body/Label) to create a high-contrast, professional hierarchy.

- **Display & Headlines (Space Grotesk):** Technical and slightly futuristic. Use these for high-level stats or screen titles to establish immediate visual authority.
- **Body & Titles (Manrope):** Warm, geometric, and highly legible. This carries the weight of the academic content, ensuring that even complex course descriptions remain readable.
- **The Scale:** 
    - **Display-LG:** 3.5rem (Space Grotesk) – For milestone achievements.
    - **Headline-SM:** 1.5rem (Space Grotesk) – For card titles and section headers.
    - **Body-MD:** 0.875rem (Manrope) – For primary content blocks.

---

## 4. Elevation & Depth: Tonal Layering

We eschew traditional structural lines in favor of **Tonal Layering** and **Ambient Light**.

- **The Layering Principle:** Depth is achieved by "stacking" tiers. Place a `surface_container_lowest` (#000000) card on a `surface_container_high` (#1c2025) section to create a recessed, high-tech "dock" effect.
- **Ambient Shadows:** When an element must float (e.g., a bottom sheet), use a shadow color tinted with `#9ba8ff` (Primary) at 5% opacity, with a blur of 32px and a Y-offset of 16px. This mimics a soft, blue-tinted glow from the screen rather than a "drop shadow."
- **The "Ghost Border" Fallback:** If a border is required for high-density forms, use the `outline_variant` (#46484c) at **15% opacity**. This provides a "suggestion" of a boundary without cluttering the sleek aesthetic.

---

## 5. Components

### Primary Buttons
- **Style:** High-contrast `primary` background with `on_primary` (#001c8e) text.
- **Radius:** `md` (0.375rem) for a sharp, professional edge.
- **States:** On hover/press, transition to `primary_dim`.

### Cards (The "Container" Unit)
- **Design:** No borders. Use `surface_container_low` for the card body. 
- **Separation:** Forbid the use of divider lines. Use vertical white space (1.5rem - 2rem) or a shift to `surface_container_highest` for nested content.

### Input Fields
- **Style:** Background should be `surface_container_highest`. 
- **Validation:** On error, the `outline` becomes `error` (#ff6e84) at 50% opacity. 
- **Feedback:** Error text must use `label-sm` in the `error` token, positioned exactly 4px below the input container.

### Progress Gauges (Signature Component)
- **Style:** For student progress, use a thick `primary` stroke on a `surface_container_lowest` track. This creates a "neon-on-dark" effect visible in the high-tech dashboard.

---

## 6. Do's and Don'ts

### Do
- **Do** use `surface_tint` (#9ba8ff) at 5% opacity as an overlay for active states on cards.
- **Do** leverage asymmetric padding (e.g., more top padding than bottom) in headlines to create an editorial, "un-templated" feel.
- **Do** use the `tertiary` (#ffa4e4) color sparingly for "In-Progress" or "Urgent" educational alerts.

### Don't
- **Don't** use 100% white (#ffffff) for text. Always use `on_surface` (#f8f9fe) to prevent "vibration" against the dark background.
- **Don't** use default Material shadows. They are too heavy and opaque for this refined, high-tech aesthetic.
- **Don't** use dividers between list items. Rely on the Spacing Scale to provide breathing room and let the typography define the breaks.