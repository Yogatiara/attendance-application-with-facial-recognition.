import { useState, useEffect } from "react";

export const DateTime = () => {
  const [date, setDate] = useState(new Date());

  useEffect(() => {
    const timerID = setInterval(() => tick(), 1000);

    return () => clearInterval(timerID);
  }, []);

  const tick = () => {
    setDate(new Date());
  };

  return (
    <div className="text-center text-3xl font-semibold">
      <h2>{date.toLocaleTimeString()}</h2>
      <h2>{date.toLocaleDateString()} </h2>
    </div>
  );
};
