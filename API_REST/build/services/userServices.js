"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getEntries = void 0;
const types_d_users_1 = require("../modelos/types_d_users");
//import userData from './users.json'
exports.getEntries = {
    getAll: () => __awaiter(void 0, void 0, void 0, function* () {
        return yield types_d_users_1.usersofDB.find();
    }),
    findById: (id) => __awaiter(void 0, void 0, void 0, function* () {
        return yield types_d_users_1.usersofDB.findOne({ name: id });
    }),
    findIdAndPassword: (mail, password) => __awaiter(void 0, void 0, void 0, function* () {
        // Si falla quitar el name:name por name, pero no deberia.
        return yield types_d_users_1.usersofDB.findOne({ mail: mail }).exec()
            .then(userResponse => {
            if (userResponse == null || userResponse.password != password) {
                return null;
            }
            else {
                return userResponse;
            }
        });
    }),
    addExperiencies: (idUser, idExp) => __awaiter(void 0, void 0, void 0, function* () {
        return yield types_d_users_1.usersofDB.findByIdAndUpdate(idUser, { $addToSet: { experiencies: idExp } });
    }),
    delExperiencies: (idUser, idExp) => __awaiter(void 0, void 0, void 0, function* () {
        return yield types_d_users_1.usersofDB.findByIdAndDelete(idUser, { $pull: { experiencies: idExp } });
    }),
    create: (entry) => __awaiter(void 0, void 0, void 0, function* () {
        return yield types_d_users_1.usersofDB.create(entry);
    }),
    update: (email, body) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            if (!email || typeof email !== 'string') {
                throw new Error('Email no proporcionado o inválido');
            }
            if (!body || Object.keys(body).length === 0) {
                throw new Error('Cuerpo de la solicitud inválido o vacío');
            }
            console.log("se llega aqui");
            console.log("Intentando actualizar el usuario:", email);
            const updatedUser = yield types_d_users_1.usersofDB.findOneAndUpdate({ mail: email.trim() }, // Elimina espacios en blanco adicionales
            { $set: body }, { new: true } // Retorna el documento actualizado
            );
            if (!updatedUser) {
                throw new Error('Usuario no encontrado o no se pudo actualizar');
            }
            return updatedUser;
        }
        catch (error) {
            console.error("Error en el servicio de actualización:", error);
            throw error;
        }
    }),
    delete: (id) => __awaiter(void 0, void 0, void 0, function* () {
        return yield types_d_users_1.usersofDB.findByIdAndDelete(id);
    })
};
