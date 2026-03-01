import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "X-HAL — Guided breathing for anxious engineers",
  description:
    "The fastest way to calm your nervous system: cyclic sighing. Deep inhale, short inhale, long exhale. 5 minutes. That's it.",
  openGraph: {
    title: "X-HAL — Guided breathing for anxious engineers",
    description:
      "Cyclic sighing in your menu bar. 5 minutes. 3 times a day. That's it.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
