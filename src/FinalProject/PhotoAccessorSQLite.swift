//
//  PhotoAccessorSQLite.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

class PhotoAccessorSQLite : PhotoAccessor {
    
    func getPhotos(_ clause: GetPhotosClause) -> [PhotoInfo] {
        var getPhtsQr =
                PhotosTable.table
                    .select([PhotosTable.id1, PhotosTable.channelId3,
                             PhotosTable.thumbnail4, PhotosTable.pendign9, PhotosTable.hashtags6])
                        .filter(PhotosTable.userId2 == clause.userId)
        
        getPhtsQr = clause.channelId != nil ? getPhtsQr.filter(PhotosTable.channelId3 == clause.channelId)
                                            : getPhtsQr
        
        getPhtsQr = getPhtsQr.order(PhotosTable.entryDate8.desc)
        
        if var htgTokens = clause.hashtags {
            if !htgTokens.isEmpty {
                var expr = PhotosTable.hashtags6.like("%\(htgTokens.removeFirst())%")
                htgTokens.forEach({ expr = expr || PhotosTable.hashtags6.like("%\($0)%") })
                getPhtsQr = getPhtsQr.where(expr)
            }
        }
        
        var photos = [PhotoInfo]()
        
        do {
            let phtsSeq = try SQLiteDb.instance.prepare(getPhtsQr)
            for phtRow in phtsSeq {
                photos.append(
                    PhotoInfo(id: phtRow.get(PhotosTable.id1),
                              channelId: phtRow.get(PhotosTable.channelId3),
                              thumbnail: phtRow.get(PhotosTable.thumbnail4),
                              hastags: phtRow.get(PhotosTable.hashtags6),
                              pending: phtRow.get(PhotosTable.pendign9))
                        )
            }
            
        }
        catch {
            print(error.localizedDescription)
        }
        
        return photos
    }
    
    func savePhoto(photo: Photo) {
        let savePhotoQr =
                PhotosTable.table
                    .insert(or: .replace,
                                PhotosTable.id1 <- photo.id,
                                PhotosTable.userId2 <- photo.userId,
                                PhotosTable.channelId3 <- photo.channelId,
                                PhotosTable.thumbnail4 <- photo.thumbnail,
                                PhotosTable.rawImage5 <- photo.rawImage,
                                PhotosTable.hashtags6 <- photo.hashTags,
                                PhotosTable.author7 <- photo.author,
                                PhotosTable.entryDate8 <- photo.entryDate
                           )
    
        do {
            _ = try SQLiteDb.instance.run(savePhotoQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getPhoto(pdsc: PhotoDescriptor) -> Photo! {
        
        let getPhotoQr =
                PhotosTable.table
                    .filter(PhotosTable.id1 == pdsc.photoId && PhotosTable.userId2 == pdsc.userId)
        do {
            if let photoRow = try SQLiteDb.instance.pluck(getPhotoQr) {
                return Photo (
                    id: photoRow.get(PhotosTable.id1),
                    channelId: photoRow.get(PhotosTable.channelId3),
                    userId: photoRow.get(PhotosTable.userId2),
                    author: photoRow.get(PhotosTable.author7),
                    entryDate: photoRow.get(PhotosTable.entryDate8),
                    rawImage:  photoRow.get(PhotosTable.rawImage5),
                    thumbnail: photoRow.get(PhotosTable.thumbnail4),
                    hashTags: photoRow.get(PhotosTable.hashtags6))
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        
        return nil
    }
    
    func saveComment(comment: Comment) {
        let saveCmmtQr =
                CommentsTable.table
                    .insert(or: .replace,
                                CommentsTable.id1 <- comment.id,
                                CommentsTable.userId2 <- comment.userId,
                                CommentsTable.photoId3 <- comment.photoId,
                                CommentsTable.comment4 <- comment.text,
                                CommentsTable.author5 <- comment.author,
                                CommentsTable.entryDate6 <- comment.entryDate
                            )
    
        do {
            _ = try SQLiteDb.instance.run(saveCmmtQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getComments(_ clause: GetCommentsClause) -> [Comment] {
        let getCmmtsQr =
                CommentsTable.table
                    .filter(CommentsTable.userId2 == clause.userId && CommentsTable.photoId3 == clause.photoId)
                        .order(CommentsTable.entryDate6.desc)
        
        var comments = [Comment]()
        
        if let cmmtSeq = try? SQLiteDb.instance.prepare(getCmmtsQr) {
            for cmmtRow in cmmtSeq {
                comments.append(
                    Comment(
                        id: cmmtRow.get(CommentsTable.id1),
                        photoId: cmmtRow.get(CommentsTable.photoId3),
                        userId: cmmtRow.get(CommentsTable.userId2),
                        text: cmmtRow.get(CommentsTable.comment4),
                        entryDate: cmmtRow.get(CommentsTable.entryDate6),
                        author: cmmtRow.get(CommentsTable.author5))
                )
            }
        }
        
        return comments
    }
    
    func incrementPhotoPending(pdsc: PhotoDescriptor) {
        let inctPhotoQr =
                PhotosTable.table
                    .filter(PhotosTable.id1 == pdsc.photoId && PhotosTable.userId2 == pdsc.userId)
                        .update(PhotosTable.pendign9++)
        
        do {
            _ = try SQLiteDb.instance.run(inctPhotoQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func clearPhotoPending(pdsc: PhotoDescriptor) {
        let clearPhotoQr =
                PhotosTable.table
                    .filter(PhotosTable.id1 == pdsc.photoId && PhotosTable.userId2 == pdsc.userId)
                        .update(PhotosTable.pendign9 <- 0)
        
        do {
            _ = try SQLiteDb.instance.run(clearPhotoQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func setPhotoHashtags(hdsc: PhotoHastagsDescriptor) {
        let sethHashtagsQr =
                PhotosTable.table
                    .filter(PhotosTable.id1 == hdsc.photoDsc.photoId && PhotosTable.userId2 == hdsc.photoDsc.userId)
                        .update(PhotosTable.hashtags6 <- hdsc.hashtags)
        
        do {
            _ = try SQLiteDb.instance.run(sethHashtagsQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getPhotoHashtags(pdsc: PhotoDescriptor) -> PhotoHastagsDescriptor! {
        let gethHashtagsQr =
                PhotosTable.table
                    .select(PhotosTable.hashtags6)
                        .filter(PhotosTable.id1 == pdsc.photoId && PhotosTable.userId2 == pdsc.userId)
        
        do {
            if let hashtagRow = try SQLiteDb.instance.pluck(gethHashtagsQr) {
                return PhotoHastagsDescriptor(photoDsc: pdsc, hashtags: hashtagRow.get(PhotosTable.hashtags6))
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
