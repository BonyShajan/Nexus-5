"use server";

import { paragraphFinisher, type ParagraphFinisherInput } from "@/ai/flows/paragraph-finisher";
import { z } from "zod";

const inputSchema = z.object({
  paragraph: z.string(),
});

export async function completeParagraphAction(
  input: ParagraphFinisherInput
): Promise<{ completedParagraph: string } | { error: string }> {
  const parsedInput = inputSchema.safeParse(input);
  if (!parsedInput.success) {
    return { error: "Invalid input." };
  }

  try {
    const result = await paragraphFinisher(parsedInput.data);
    return { completedParagraph: result.completedParagraph };
  } catch (e) {
    console.error("Paragraph finisher failed:", e);
    return { error: "Failed to complete the paragraph. Please try again later." };
  }
}
// components/auth-form.tsx
"use client";

import React, { useState } from "react";
import { auth, googleProvider, signInWithPopup, createUserWithEmailAndPassword, signInWithEmailAndPassword } from "@/lib/firebase";
import { GoogleAuthProvider } from "firebase/auth";

interface AuthFormProps {
  onSuccess: () => void;
}

const AuthForm = ({ onSuccess }: AuthFormProps) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isSignUp, setIsSignUp] = useState(true);
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleEmailAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setIsLoading(true);

    try {
      if (isSignUp) {
        await createUserWithEmailAndPassword(auth, email, password);
        setIsSignUp(false); // Switch to sign-in view after successful sign-up
      } else {
        await signInWithEmailAndPassword(auth, email, password);
        onSuccess();
      }
    } catch (err) {
      if (err instanceof Error) {
        setError(err.message);
      } else {
        setError("An unknown error occurred.");
      }
    } finally {
      setIsLoading(false);
    }
  };

  const handleGoogleSignIn = async () => {
    setError("");
    setIsLoading(true);

    try {
      await signInWithPopup(auth, googleProvider);
      onSuccess();
    } catch (err) {
      if (err instanceof Error) {
        if ((err as any).code === 'auth/popup-closed-by-user') {
          setError("Sign-in process was cancelled. Please try again.");
        } else {
          setError(err.message);
        }
      } else {
        setError("An unknown error occurred during Google sign-in.");
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="w-full max-w-md">
      <h2 className="text-2xl font-bold mb-6 text-center">
        {isSignUp ? "Create Account" : "Welcome Back"}
      </h2>
      
      {error && (
        <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm">
          {error}
        </div>
      )}

      <form onSubmit={handleEmailAuth} className="space-y-4">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-gray-700">
            Email
          </label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className="mt-1 w-full p-2 border rounded-md"
            autoComplete="email"
          />
        </div>

        <div>
          <label htmlFor="password" className="block text-sm font-medium text-gray-700">
            Password
          </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            className="mt-1 w-full p-2 border rounded-md"
            autoComplete={isSignUp ? "new-password" : "current-password"}
          />
        </div>

        <button
          type="submit"
          disabled={isLoading}
          className={`w-full py-2 px-4 rounded-md text-white ${
            isLoading ? "bg-blue-300" : "bg-blue-600 hover:bg-blue-700"
          }`}
        >
          {isLoading ? "Processing..." : isSignUp ? "Sign Up" : "Sign In"}
        </button>
      </form>

      <div className="my-6 flex items-center">
        <div className="flex-grow border-t border-gray-300"></div>
        <span className="mx-4 text-gray-500">or</span>
        <div className="flex-grow border-t border-gray-300"></div>
      </div>

      <button
        onClick={handleGoogleSignIn}
        disabled={isLoading}
        className="w-full flex items-center justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
      >
        <svg className="mr-2 h-5 w-5" aria-hidden="true" focusable="false" data-prefix="fab" data-icon="google" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 488 512"><path fill="currentColor" d="M488 261.8C488 403.3 391.1 504 248 504 110.8 504 0 393.2 0 256S110.8 8 248 8c66.8 0 126 21.2 177.2 56.4l-64.2 64.2C325.8 97.2 289.4 80 248 80c-81.6 0-148.8 67.2-148.8 148.8s67.2 148.8 148.8 148.8c99.2 0 128.8-72.4 132.8-109.2H248v-85.2h239.2c4.4 24.8 8 50.8 8 78.2z"></path></svg>
        Continue with Google
      </button>

      <div className="mt-4 text-center text-sm">
        <button
          type="button"
          onClick={() => setIsSignUp(!isSignUp)}
          className="text-blue-600 hover:text-blue-500"
        >
          {isSignUp ? "Already have an account? Sign In" : "Need an account? Sign Up"}
        </button>
      </div>
    </div>
  );
};

export default AuthForm;
