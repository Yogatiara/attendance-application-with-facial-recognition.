import logoDTS from "/Logo TDS.png";

export const Loading = () => {
  return (
    <div className="w-60 animate-bounce">
      <img src={logoDTS} alt="TDS Logo Loading" />
      <h1 className="text-center text-lg font-bold">Loading...</h1>
    </div>
  );
};
