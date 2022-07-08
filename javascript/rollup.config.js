import resolve from "@rollup/plugin-node-resolve";
import { version } from "./package.json";
import { terser } from "rollup-plugin-terser";

const year = new Date().getFullYear();

const banner = `/*!
  Rails Live Reload ${version}
  Copyright © ${year} RailsJazz
  https://railsjazz.com
 */
`;

export default [
  {
    input: "polling.js",
    output: [
      {
        name: "RailsLiveReload",
        file: "../lib/rails_live_reload/javascript/polling.js",
        format: "iife",
        banner: banner,
        plugins: [terser()],
      },
    ],
    plugins: [resolve()],
    watch: {
      include: "**",
    },
  },
  {
    input: "long_polling.js",
    output: [
      {
        name: "RailsLiveReload",
        file: "../lib/rails_live_reload/javascript/long_polling.js",
        format: "iife",
        banner: banner,
        plugins: [terser()],
      },
    ],
    plugins: [resolve()],
    watch: {
      include: "**",
    },
  },
  {
    input: "websocket.js",
    output: [
      {
        name: "RailsLiveReload",
        file: "../lib/rails_live_reload/javascript/websocket.js",
        format: "iife",
        banner: banner,
        plugins: [terser()],
      },
    ],
    plugins: [resolve()],
    watch: {
      include: "**",
    },
  },
];
