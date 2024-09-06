import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import { MainLayout } from "./components/MainLayout";
import { WaterMonitoringDetail } from "./pages/water_monitoring/water_monitoring_detail/WaterMonitoringDetail";
import { History } from "./pages/history/History";
import { WaterMonitoring } from "./pages/water_monitoring/WaterMonitoring";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<MainLayout />}>
          <Route path="water-monitoring">
            <Route index={true} element={<WaterMonitoring />} />
            <Route path=":id" element={<WaterMonitoringDetail />} />
          </Route>
          <Route path="history" element={<History />} />
        </Route>
      </Routes>
    </Router>
  );
};
export default App;
