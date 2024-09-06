export const HistoryTable = () => {
  return (
    <div className="overflow-x-auto">
      <table className="table table-zebra border border-gray-300 text-center">
        {/* head */}
        <thead className="text-md bg-[#5daeff] uppercase text-white">
          <tr className="border-gray-300">
            <th>Id</th>
            <th>Date Time</th>
            <th>Temperature</th>
            <th>pH</th>
            <th>Turbidity</th>
            <th>TDS</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody className="border-gray-300">
          {/* row 1 */}
          <tr className="border-gray-300">
            <th>1</th>
            <td>6:37:47 6/10/2024</td>
            <td>30.54°C</td>
            <td>7.17</td>
            <td>55 NTU</td>
            <td>30.5 PPM</td>
            <td className="text-red-500">alert</td>
            <td className="space-x-3">
              <button className="btn btn-warning text-white">
                See details
              </button>

              <button className="btn btn-error text-white">Delete</button>
            </td>
          </tr>
          {/* row 2 */}
          <tr className="border-gray-300">
            <th>2</th>
            <td>6:37:47 6/10/2024</td>
            <td>30.54°C</td>
            <td>7.17</td>
            <td>55 NTU</td>
            <td>30.5 PPM</td>
            <td className="text-red-500">alert</td>
            <td className="space-x-3">
              <button className="btn btn-warning text-white">
                See details
              </button>

              <button className="btn btn-error text-white">Delete</button>
            </td>
          </tr>
          {/* row 3 */}
          <tr className="border-gray-300">
            <th>3</th>
            <td>6:37:47 6/10/2024</td>
            <td>30.54°C</td>
            <td>7.17</td>
            <td>55 NTU</td>
            <td>30.5 PPM</td>
            <td className="text-red-500">alert</td>
            <td className="space-x-3">
              <button className="btn btn-warning text-white">
                See details
              </button>

              <button className="btn btn-error text-white">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  );
};
