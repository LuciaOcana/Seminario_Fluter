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
    update: async (email: string, body: object) => {
        try {
            if (!email || typeof email !== 'string') {
                throw new Error('Email no proporcionado o inválido');
            }
    
            if (!body || Object.keys(body).length === 0) {
                throw new Error('Cuerpo de la solicitud inválido o vacío');
            }
            console.log ("se llega aqui");
            console.log("Intentando actualizar el usuario:", email);
    
            const updatedUser = await usersofDB.findOneAndUpdate(
                { mail: email.trim() }, // Elimina espacios en blanco adicionales
                { $set: body },
                { new: true } // Retorna el documento actualizado
            );
    
            if (!updatedUser) {
                throw new Error('Usuario no encontrado o no se pudo actualizar');
            }
    
            return updatedUser;
        } catch (error) {
            console.error("Error en el servicio de actualización:", error);
            throw error;
        }
    },
    
    delete: async(id:string)=>{
        return await usersofDB.findByIdAndDelete(id);
    }
}