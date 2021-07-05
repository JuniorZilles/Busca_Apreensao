const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.insertConcluidosDate = functions.database.ref('placas/concluidos/{pushId}').onCreate((val, context) => {
    if (val.val()) {
        var data = new Date(Date.now());
        var mes = data.getMonth() + 1;
        var ano = data.getFullYear();
        var mesano = mes.toString() + ano.toString();
        var qtd = 1;
        admin.database().ref('estatisticas/concluidos').on('value', dado => {
            if (dado.val()) {
                var s = dado.key;
                if (s === mesano) {
                    qtd = parseInt(dado.val()) + 1;
                }
            }
        }
        );
        return admin.database().ref('estatisticas/concluidos/' + mesano.toString()).set(qtd);
    }
});
exports.insertEmandamentoDate = functions.database.ref('placas/emandamento/{pushId}').onCreate((val, context) => {
    if (val.val()) {
        var data = new Date(Date.now());
        var mes = data.getMonth() + 1;
        var ano = data.getFullYear();
        var mesano = mes.toString() + ano.toString();
        var qtd = 1;
        admin.database().ref('estatisticas/emandamento').on('value', dado => {
            if (dado.val()) {
                var s = dado.key;
                if (s === mesano) {
                    qtd = parseInt(dado.val()) + 1;
                }
            }
        }
        );
        return admin.database().ref('estatisticas/emandamento/' + mesano).set(qtd);
    }
});

exports.insertDecoyConcluidoDate = functions.database.ref('placas/emandamento/{pushId}').onCreate((val, context) => {
    if (val.val()) {
        var data = new Date(Date.now());
        var mes = data.getMonth() + 1;
        var ano = data.getFullYear();
        var mesano = mes.toString() + ano.toString();
        var qtd = 0;
        admin.database().ref('estatisticas/concluidos').on('value', dado => {
            if (dado.val()) {
                var s = dado.key;
                if (s === mesano) {
                    qtd = parseInt(dado.val()) + 1;
                }
            }
        }
        );
        if(qtd > 0)
            return admin.database().ref('estatisticas/concluidos/' + mesano).set(qtd);
        else
            return null;
    }
});

exports.insertDecoyEmAndamentoDate = functions.database.ref('placas/concluidos/{pushId}').onCreate((val, context) => {
    if (val.val()) {
        var data = new Date(Date.now());
        var mes = data.getMonth() + 1;
        var ano = data.getFullYear();
        var mesano = mes.toString() + ano.toString();
        var qtd = 0;
        admin.database().ref('estatisticas/emandamento').on('value', dado => {
            if (dado.val()) {
                var s = dado.key;
                if (s === mesano) {
                    qtd = parseInt(dado.val()) + 1;
                }
            }
        }
        );
        if(qtd > 0)
            return admin.database().ref('estatisticas/emandamento/' + mesano.toString()).set(qtd);
        else
            return null;
    }
});