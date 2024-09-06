import PropTypes from "prop-types";

import DateIcon from "@assets/icons/date icon.png";

export const MonitoringDateCard = ({ monitoringData }) => {
  return (
    <div className="w-96 rounded-3xl border bg-slate-100 shadow-xl">
      <div className="p-6">
        <h2 className="card-title text-2xl">Monitoring Date : </h2>
        <div className="flex flex-row place-content-center items-center gap-4 p-2 pt-3">
          <img src={DateIcon} alt="Temeperature Icon" className="w-8" />

          <div className="flex flex-row items-center">
            <h2 className="text-2xl">
              {monitoringData.time}&nbsp;&nbsp;{monitoringData.date}
            </h2>
          </div>
        </div>
      </div>
    </div>
  );
};

MonitoringDateCard.propTypes = {
  monitoringData: PropTypes.object.isRequired,
};
