import { usersInterface, UsersInterfacePrivateInfo } from '../modelos/types_d_users'
import * as userServices from '../services/userServices'
import { Request, Response } from 'express'


export async function logIn(req:Request,res:Response):Promise<Response> {
    try{
        const { mail,password } = req.body as UsersInterfacePrivateInfo;
        const user:usersInterface|null = await userServices.getEntries.findIdAndPassword(mail, password);
        console.log("Logeao:",user);
        if (user!=null){
            return res.status(200).json(user);
        } else {
            return res.status(400).json({message:'User or password incorrect'})
        }
    } catch(e){
        return res.status(500).json({ e: 'Failed to find user' });
    }
}

export async function updateUser(req: Request, res: Response): Promise<Response> {
    try {
        const { id } = req.params;  // ID del usuario a modificar
        const updatedData = req.body;  // Datos actualizados

        const updatedUser = await userServices.getEntries.update(id, updatedData);

        if (updatedUser) {
            console.log(updatedUser);
            return res.status(200).json({ message: 'Usuario actualizado', user: updatedUser });
            
        } else {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }
    } catch (error) {
        console.error('Error al actualizar usuario:', error);
        return res.status(500).json({ message: 'Error al actualizar el usuario' });
    }
   
}

