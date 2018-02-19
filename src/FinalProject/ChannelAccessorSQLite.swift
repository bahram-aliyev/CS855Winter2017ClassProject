//
//  ChannelAccessorSQLite.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

class ChannelAccessorSQLite : ChannelAccessor {
    
    func getChannelPendings(userId: String) -> [ChannelActivityInfo] {
        
        let chnlPendingsQr = ChannelNotifTable.table.filter(ChannelNotifTable.userId2 == userId)
        
        var chnlActvsInfo = [ChannelActivityInfo]()
        
        do {
            let pndgsSeq = try SQLiteDb.instance.prepare(chnlPendingsQr)
            for pndgsRow in pndgsSeq {
                chnlActvsInfo.append(
                    ChannelActivityInfo(channelId: pndgsRow.get(ChannelNotifTable.channelId1),
                                        lastActivity: pndgsRow.get(ChannelNotifTable.lastActivity4),
                                        peding: pndgsRow.get(ChannelNotifTable.pendign3))
                )
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        return chnlActvsInfo
    }
    
    func updateChannelActivity(actvtDsc: ChannelActivityDescriptor) {
        let updChnlActvtQr =
                ChannelNotifTable.table
                    .insert(or: .replace,
                            ChannelNotifTable.channelId1 <- actvtDsc.channelId,
                            ChannelNotifTable.userId2 <- actvtDsc.userId,
                            ChannelNotifTable.pendign3++, ChannelNotifTable.lastActivity4 <- actvtDsc.lastActivity)
        do {
            _ = try SQLiteDb.instance.run(updChnlActvtQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func clearChannelPending(cdsc: ChannelDescriptor) {
        let clearChnlPndgsQr =
                ChannelNotifTable.table
                    .filter(ChannelNotifTable.userId2 == cdsc.userId && ChannelNotifTable.channelId1 == cdsc.channelId)
                        .update(ChannelNotifTable.pendign3 <- 0)
        
        do {
            _ = try SQLiteDb.instance.run(clearChnlPndgsQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }

}
