import { Types } from 'mongoose';
import { usersInterface, usersofDB } from '../modelos/types_d_users'
//import userData from './users.json'


export const getEntries = {
    getAll: async()=>{
    return await usersofDB.find();
    },
    findById: async(id:string)=>{
        return await usersofDB.findOne({name:id});
    },
    findIdAndPassword: async(mail:string,password:string): Promise<usersInterface | null>=>{
        // Si falla quitar el name:name por name, pero no deberia.
        return await usersofDB.findOne({mail:mail}).exec()
        .then(userResponse=>{
            if (userResponse == null || userResponse.password != password){
                return null;
            } else {
                return userResponse;
            }
        });
    },
    addExperiencies: async(idUser:string,idExp:string)=>{
        return await usersofDB.findByIdAndUpdate(idUser,{$addToSet:{experiencies:idExp}});
    },
    delExperiencies: async(idUser:string,idExp:string)=>{
        return await usersofDB.findByIdAndDelete(idUser,{$pull:{experiencies:idExp}});
    },
    create: async(entry:object)=>{
        return await usersofDB.create(entry);
    },
    
    
    update: async (id: string, body: object) => {
        try {
            return await usersofDB.findByIdAndUpdate(id, body, { new: true });
        } catch (error) {
            console.error('Error actualizando usuario:', error);
            throw error;
        }
    },

    
    delete: async(id:string)=>{
        const objectId = new Types.ObjectId(id);
        return await usersofDB.findByIdAndDelete(objectId);
    }
}

