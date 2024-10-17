
import Foundation

public class DestinationManager {
    static let shared = DestinationManager()
    
    public var destinationInfoList = [DestinationInformation]()
    
    public func makeDestinationInformationList(outputSecotors: OutputSectors) {
        let user_group_name = outputSecotors.user_group_name
        let sectors = outputSecotors.sectors
        for sector in sectors {
            let buildings = sector.buildings
            for building in buildings {
                // sector -> building
            }
        }
    }
    
}
