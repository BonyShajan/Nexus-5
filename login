// src/app/login/page.tsx
"use client";

import AuthForm from "@/app/auth-form";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const router = useRouter();

  const handleSuccess = () => {
    router.push("/");
  };

  return (
    <div className="flex min-h-screen w-full items-center justify-center bg-background p-4 font-body">
      <div className="flex w-full max-w-[900px] h-auto min-h-[620px] max-h-[90vh] rounded-xl shadow-2xl overflow-hidden flex-col lg:flex-row lg:h-[620px]">
        <aside className="flex flex-col items-center justify-center gap-4 bg-gradient-to-br from-primary via-teal-400 to-secondary p-10 text-center text-primary-foreground lg:flex-1 [text-shadow:0_0_5px_rgba(0,0,0,0.5)]">
          <div className="animate-bounce text-6xl">👏</div>
          <h1 className="font-headline text-4xl font-extrabold">Welcome to Clap-To-Save!</h1>
          <p className="max-w-xs text-lg">Effortlessly save your work by clapping. Join the future of intuitive productivity now.</p>
        </aside>
        <main className="flex flex-col items-center justify-center bg-card p-6 sm:p-9 lg:flex-[1.4] overflow-y-auto">
          <AuthForm onSuccess={handleSuccess} />
        </main>
      </div>
    </div>
  );
}
