/*enum ClusterWrapper {
    case basic(BasicCluster)
    case identify(IdentifyCluster)
    case onOff(OnOffCluster)
    case analogInput(AnalogInputCluster)
    case colorControl(ColorControlCluster)
    case groups(GroupsCluster)
    case level(LevelCluster)
    case scenes(ScenesCluster)
    case temperatureMeasurement(TemperatureMeasurmentsCluster)
    
    func addTo(clusterlist: UnsafeMutablePointer<ClusterList>, role: ZCLClusterRole) throws (ESPError){
        switch self {
            case .basic(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .identify(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .onOff(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .analogInput(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .colorControl(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .groups(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .level(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .scenes(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
            case .temperatureMeasurement(var cluster): 
                try cluster.addTo(clusterlist: clusterlist, role: role) 
    }
}
}
*/