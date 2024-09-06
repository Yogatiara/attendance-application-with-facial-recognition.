import PropTypes from "prop-types";
import { Link } from "react-router-dom";

export const WaterMonitoringTable = ({ monitoringData, handleDelete }) => {
  const sortedData = monitoringData.sort((a, b) => {
    const timestampA = new Date(`${a.date} ${a.time}`).getTime();
    const timestampB = new Date(`${b.date} ${b.time}`).getTime();

    return timestampB - timestampA;
  });

  return (
    <>
      <div className="w-[850px] overflow-x-auto">
        <table className="table table-zebra border border-gray-300 text-center">
          {/* head */}
          <thead className="text-md bg-[#5daeff] uppercase text-white">
            <tr className="border-gray-300">
              <th>Id</th>
              <th>Date Time</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody className="border-gray-300">
            {sortedData.map((data, i) => (
              <tr key={i} className="border-gray-300 text-base">
                <td className="font-bold">{data.id}</td>
                <td>
                  {data.time}, {data.date}
                </td>
                <td
                  className={`text-lg font-medium uppercase ${data.status === "alert" ? "text-red-500" : "text-green-600"}`}
                >
                  {data.status}
                </td>
                <td className="space-x-3">
                  <Link to={`/water-monitoring/${data.id}`}>
                    <button className="btn btn-warning text-white">
                      See details
                    </button>
                  </Link>
                  <button
                    onClick={() => handleDelete(data.id)}
                    className="btn btn-error text-white"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
};

WaterMonitoringTable.propTypes = {
  monitoringData: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      date: PropTypes.string.isRequired,
      time: PropTypes.string.isRequired,
      status: PropTypes.string.isRequired,
    }),
  ).isRequired,
  handleDelete: PropTypes.func,
};
