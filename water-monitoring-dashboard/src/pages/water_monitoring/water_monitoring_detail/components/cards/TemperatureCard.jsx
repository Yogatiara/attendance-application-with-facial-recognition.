import PropTypes from "prop-types";

import TemperatureIcon from "@assets/icons/temperature icon.png";

export const TemperatureCard = ({ monitoringData }) => {
  return (
    <div className="card w-[450px] rounded-xl border bg-[#eca9b0]">
      <div className="card-body">
        <h2 className="card-title text-2xl">Temperature : </h2>
        <div className="flex flex-row place-content-center items-center gap-2 pt-3">
          <img src={TemperatureIcon} alt="Temeperature Icon" className="w-28" />

          <div className="flex flex-row items-end gap-1 text-gray-600">
            <h2 className="text-6xl">{monitoringData.temperature}</h2>
            <span className="text-2xl">&#176;Celcius</span>
          </div>
        </div>
      </div>
    </div>
  );
};

TemperatureCard.propTypes = {
  monitoringData: PropTypes.object.isRequired,
};
