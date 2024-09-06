import PropTypes from "prop-types";

import { IoWaterOutline } from "react-icons/io5";

export const PHCard = ({ monitoringData }) => {
  return (
    <div className="card w-[450px] rounded-xl border bg-[#79b3ff]">
      <div className="card-body">
        <h2 className="card-title text-2xl">PH Water Level : </h2>
        <div className="flex flex-row place-content-center items-center gap-4 pb-3 pt-5">
          {<IoWaterOutline className="text-8xl" />}
          <div className="flex flex-row items-end gap-1 text-gray-600">
            <h2 className="text-6xl">pH {monitoringData.ph}</h2>
            {/* <span className="text-2xl">&#176;Celcius</span> */}
          </div>
        </div>
      </div>
    </div>
  );
};

PHCard.propTypes = {
  monitoringData: PropTypes.object.isRequired,
};
