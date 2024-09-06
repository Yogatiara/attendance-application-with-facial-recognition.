/* eslint-disable react/prop-types */
import { Pie } from "react-chartjs-2";
import "chart.js/auto";
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from "chart.js";

ChartJS.register(ArcElement, Tooltip, Legend);

export const Chart = ({ monitoringData }) => {
  return (
    <>
      <div className="w-[500px]">
        <Pie
          data={{
            labels: ["good", "alert"],
            datasets: [
              {
                data: [
                  monitoringData.filter((data) => data.status === "good")
                    .length,
                  monitoringData.filter((data) => data.status === "alert")
                    .length,
                ],
                backgroundColor: ["#66FF66", "#FF6666"],
              },
            ],
          }}
          options={{
            plugins: {
              title: {
                display: true,
                text: "comparison of the number of water quality statuses",
                font: {
                  size: 25,
                },
                align: "center",
                padding: 6, // Center alignment
              },
            },
          }}
        />
      </div>
    </>
  );
};
