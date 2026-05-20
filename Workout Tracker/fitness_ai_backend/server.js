import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import Groq from "groq-sdk";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

app.post("/generate-workout", async (req, res) => {
  try {
    const { goal, level, days } = req.body;

    const completion = await groq.chat.completions.create({
      model: "llama-3.1-8b-instant",

      messages: [
        {
          role: "system",
          content: "You are a helpful fitness coach. Give safe workout advice.",
        },

        {
          role: "user",
          content: `
Create a ${days}-day workout plan
for a ${level} level person
whose goal is ${goal}.

Include:
- exercises
- sets
- reps
- rest times
- short motivation
          `,
        },
      ],

      temperature: 0.7,
      max_tokens: 800,
    });

    const aiResponse = completion.choices[0]?.message?.content || "No response";

    res.json({
      result: aiResponse,
    });
  } catch (error) {
    console.log("Groq Error:", error);

    res.status(500).json({
      error: error.message,
    });
  }
});

app.listen(3000, () => {
  console.log("AI backend running on http://localhost:3000");
});
