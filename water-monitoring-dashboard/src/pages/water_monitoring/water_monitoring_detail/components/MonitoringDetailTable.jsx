/* eslint-disable react/prop-types */

import PropTypes from "prop-types";

export const MonitoringDetailTable = ({ records }) => {
  return (
    <div className="overflow-x-auto">
      <table className="table table-zebra border border-gray-300 text-center">
        <thead className="text-md bg-[#5daeff] uppercase text-white">
          <tr className="border-gray-300">
            <th>Id</th>
            <th>Date Time</th>
            <th>Temperature</th>
            <th>pH</th>
            <th>Turbidity</th>
            <th>TDS</th>
          </tr>
        </thead>
        <tbody className="border-gray-300">
          {records.map((data, i) => (
            <tr key={i} className="border-gray-300">
              <th>{data.id}</th>
              <td>
                {data.time}, {data.date}
              </td>
              <td>{data.temperature}°C</td>
              <td>pH {data.ph}</td>
              <td>{data.turbidity} NTU</td>
              <td>{data.tds} PPM</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

MonitoringDetailTable.propTypes = {
  records: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      date: PropTypes.string.isRequired,
      time: PropTypes.string.isRequired,

      ph: PropTypes.string.isRequired,
      turbidity: PropTypes.string.isRequired,
      tds: PropTypes.string.isRequired,
    }),
  ).isRequired,
};
