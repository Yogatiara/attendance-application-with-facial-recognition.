import PropTypes from "prop-types";

export const WaterStatusCard = ({ monitoringData }) => {
  return (
    <div
      className={`grid h-72 w-72 ${monitoringData.status == "alert" ? "animate-blinkingBg" : "bg-green-400"} content-center rounded-full shadow-xl`}
    >
      <div className="flex justify-center">
        <h2
          className={`${monitoringData.status == "alert" ? "animate-blinkingText" : "text-white"} text-5xl font-bold uppercase`}
        >
          {monitoringData.status == "alert" ? (
            <>{monitoringData.status} !!!</>
          ) : (
            <>{monitoringData.status}</>
          )}
        </h2>{" "}
      </div>
    </div>
  );
};

WaterStatusCard.propTypes = {
  monitoringData: PropTypes.object.isRequired,
};
