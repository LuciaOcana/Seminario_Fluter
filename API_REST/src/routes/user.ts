    import express from 'express'
    import * as userServices from '../services/userServices'
    import { logIn } from '../controllers/user_controller'

    //import toNewUser from '../extras/utils'

    const router = express.Router()

    router.get('/', async(_req, res) => {
        const data = await userServices.getEntries.getAll()
        return res.json(data);
    })

    router.get('/:id', async(req, res) => {
        const data = await userServices.getEntries.findById(req.params.id)
        return res.json(data);
    })

    router.post('/newUser', async(req, res) => {
        const data = await userServices.getEntries.create(req.body)
        return res.json(data);
    })

    router.post('/logIn', logIn)

    router.post('/addExperiencias/:idUser/:idExp', async(req, res) => {
        const data = await userServices.getEntries.addExperiencies(req.params.idUser,req.params.idExp)
        return res.json(data);
    })

    router.put('/updateByMail/:email', async (req, res) => {
        try {
            const { email } = req.params;
            const body = req.body;
            console.log("Body recibido:", req.body);

            if (!email) {
                return res.status(400).json({ error: 'Email es obligatorio' });
            }
    
            if (!body || Object.keys(body).length === 0) {
                return res.status(400).json({ error: 'El cuerpo de la solicitud no puede estar vacío' });
            }
    
            // Llamar al servicio para actualizar el usuario
            const updatedUser = await userServices.getEntries.update(email, body);
    
            return res.status(200).json({ 
                message: 'Usuario actualizado correctamente', 
                data: updatedUser 
            });
        } catch (error) {
            console.error("Error en el endpoint /updateByMail:", error);
    
            if (error instanceof Error) {
                return res.status(400).json({ error: error.message });
            }
    
            return res.status(500).json({ error: 'Error interno del servidor' });
        }
    })    
    
    router.delete('/:id', async(req, res) => {
        const data = await userServices.getEntries.delete(req.params.id)
        return res.json(data);
    })

    router.delete('/delParticipant/:idUser/:idExp', async(req, res) => {
        const data = await userServices.getEntries.delExperiencies(req.params.idUser,req.params.idExp)
        return res.json(data);
    })


    export default router