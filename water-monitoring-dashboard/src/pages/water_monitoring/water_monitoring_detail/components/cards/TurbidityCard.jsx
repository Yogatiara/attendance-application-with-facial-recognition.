import PropTypes from "prop-types";

import TurbidityIcon from "@assets/icons/turbidity icon.png";

export const TurbidityCard = ({ monitoringData }) => {
  return (
    <div className="card w-[450px] rounded-xl border bg-[#b4a19e]">
      <div className="card-body">
        <h2 className="card-title text-2xl">Turbidity : </h2>
        <div className="flex flex-row place-content-center items-center gap-4 pb-2 pt-6">
          <img src={TurbidityIcon} alt="Turbidity Icon" className="w-24" />

          <div className="flex flex-row items-end gap-1 text-gray-600">
            <h2 className="text-6xl">{monitoringData.turbidity}</h2>
            <span className="text-2xl">NTU</span>
          </div>
        </div>
      </div>
    </div>
  );
};

TurbidityCard.propTypes = {
  monitoringData: PropTypes.object.isRequired,
};
