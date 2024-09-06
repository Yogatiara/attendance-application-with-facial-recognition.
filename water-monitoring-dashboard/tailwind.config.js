import daisyui from "./node_modules/daisyui";
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      keyframes: {
        blinkingBg: {
          "0%, 100%": { backgroundColor: "#ef4444" },
          "50%": { backgroundColor: "#fee2e2" },
        },
        blinkingText: {
          "0%, 100%": { color: "#fee2e2" },
          "50%": { color: "#ef4444" },
        },
      },
      animation: {
        blinkingBg: "blinkingBg 1.7s ease-in-out infinite",
        blinkingText: "blinkingText 1.7s ease-in-out infinite",
      },
    },
    fontFamily: {
      firaSans: ["Fira Sans", "sans-serif"],
    },
  },
  plugins: [daisyui],
  daisyui: {
    themes: [
      {
        myTheme: {
          ".menu li > *:not(ul):not(.menu-title):not(details).active": {
            backgroundColor: "#99CCFF",
            color: "#FFFFFF",
          },
          // ".menu li > *:not(details):focus": {
          //   backgroundColor: "#99CCFF",
          // },
        },
      },
    ],
  },
};
