import Image from "next/image";

function AppleIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 63 63"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M52.16 55.2532C49.1232 58.2084 45.8074 57.7418 42.6156 56.342C39.2379 54.911 36.1391 54.8488 32.5755 56.342C28.1132 58.2706 25.7581 57.7107 23.0931 55.2532C7.97086 39.6063 10.202 15.7782 27.3695 14.9072C31.5529 15.1249 34.4657 17.2091 36.9138 17.3958C40.5704 16.6492 44.0721 14.5028 47.9766 14.7828C52.6558 15.1561 56.1885 17.0225 58.5126 20.3821C48.8443 26.1991 51.1374 38.9842 60 42.5615C58.2337 47.2276 55.9406 51.8625 52.129 55.2843L52.16 55.2532ZM36.6039 14.7206C36.1391 7.78365 41.748 2.05993 48.1935 1.5C49.0922 9.52565 40.9423 15.4982 36.6039 14.7206Z"
        fill="url(#apple-grad)"
      />
      <defs>
        <linearGradient
          id="apple-grad"
          x1="36.5"
          y1="14.17"
          x2="36.5"
          y2="51.31"
          gradientUnits="userSpaceOnUse"
        >
          <stop stopColor="white" />
          <stop offset="1" stopColor="#BDE4FF" />
        </linearGradient>
      </defs>
    </svg>
  );
}

export default function Home() {
  return (
    <main className="min-h-screen bg-bg px-6 py-16 md:px-20 lg:py-24">
      <div className="mx-auto max-w-[860px]">
        {/* Header */}
        <header className="flex flex-col items-start gap-6 sm:flex-row sm:items-center sm:justify-between">
          <div className="shrink-0">
            <Image
              src="/logo.svg"
              alt="X-HAL"
              width={220}
              height={74}
              priority
            />
          </div>
          <p className="text-right text-lg font-medium leading-relaxed sm:text-xl">
            <span className="text-text-dark">
              X-HAL: Guided breathing for anxious engineers.{" "}
            </span>
            <br className="hidden sm:inline" />
            <span className="text-text-muted">
              HAL is here. Calm down. Exhale. Get back to work, Dave.
            </span>
          </p>
        </header>

        {/* Hero */}
        <section className="mt-28 sm:mt-36 lg:mt-44">
          <h1 className="text-2xl font-medium text-text-dark sm:text-3xl lg:text-[32px]">
            No shit you&apos;re stressed.
          </h1>
          <div className="mt-5 space-y-6 text-lg font-medium leading-relaxed text-text-muted sm:text-xl">
            <p>
              AI is taking your job. The 6 agents you&apos;re running now
              won&apos;t help.
            </p>
            <p>
              The fastest way to calm your nervous system: cyclic sighing.
              <br />
              Deep inhale, short inhale, long exhale.
              <br />5 minutes. 3 times a day. That&apos;s it.
            </p>
          </div>
        </section>

        {/* CTA */}
        <div className="mt-14 flex flex-col items-start gap-6 sm:mt-16 sm:flex-row sm:items-center sm:gap-10">
          <a
            href="/X-HAL.zip"
            download
            className="group relative inline-flex items-center gap-3 rounded-full bg-gradient-to-b from-btn-from to-btn-to px-8 py-4 text-lg font-medium text-white shadow-[0_15px_44px_0_rgba(0,141,211,0.24)] transition-all hover:shadow-[0_20px_50px_0_rgba(0,141,211,0.35)] hover:brightness-110 sm:px-10 sm:py-5 sm:text-xl"
          >
            <span className="pointer-events-none absolute inset-0 rounded-[inherit] shadow-[inset_0_6px_11px_0_rgba(220,225,232,0.4),inset_0_-2px_5px_0_rgba(110,127,150,0.8)]" />
            <AppleIcon className="relative z-10 size-5 sm:size-6" />
            <span className="relative z-10">Download for Mac</span>
          </a>
          <span className="text-lg text-text-muted">Try it, Dave.</span>
        </div>

        {/* Disclaimer */}
        <p className="mt-20 max-w-3xl text-sm leading-relaxed text-text-muted sm:mt-24 sm:text-base">
          This is the very serious appendix. Breath-work works if you&apos;re
          not dead. The cyclic sighing technique works if you&apos;re not
          underwater. X-HAL is not made for underwater use. Or you could try but
          it&apos;s not going to be a very fun 5 minutes. X-HAL in the water for
          a long time is actually called drowning. Ok enough with the crap.
          Here&apos;s a design tip for you. If you want to look more legitimate,
          just write long copy at the bottom of your visuals. Even if you
          don&apos;t write anything important. Does this look like this app is
          not from a medical company? Ah! It does almost right?
        </p>
      </div>
    </main>
  );
}
