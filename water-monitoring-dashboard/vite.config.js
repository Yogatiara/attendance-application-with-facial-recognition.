import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@assets": path.resolve(__dirname, "src/assets"),
      "@api": path.resolve(__dirname, "src/api"),
      "@page": path.resolve(__dirname, "src/pages"),
      "@public-components": path.resolve(__dirname, "src/components"),
      "@water-monitoring-detail-components": path.resolve(
        __dirname,
        "src/pages/water_monitoring/water_monitoring_detail/components",
      ),
    },
  },
});
