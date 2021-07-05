class ErrorDefinition {
  String obterLoginErrors(String erro) {
    String _mensagem = '';
    if (erro.contains('ERROR_WRONG_PASSWORD')) {
      _mensagem = 'Senha inválida';
    } else if (erro.contains('ERROR_INVALID_EMAIL')) {
      _mensagem = 'Email inválida';
    } else if (erro.contains('ERROR_USER_NOT_FOUND')) {
      _mensagem = 'Email não cadastrado';
    } else if (erro.contains('ERROR_USER_DISABLED')) {
      _mensagem = 'Usuário desativado';
    } else if (erro.contains('ERROR_TOO_MANY_REQUESTS')) {
      _mensagem =
          'Foram realizadas muitas requisições seguidas aguarde e tente novamente mais tarde';
    } else if (erro.contains('ERROR_OPERATION_NOT_ALLOWED')) {
      _mensagem = 'Operação não permitida';
    }else{
      _mensagem = erro;
    }
    return _mensagem;
  }

   String obterRealtimeErrors(String erro) {
    String _mensagem = '';
    if (erro.contains('DISCONNECTED')) {
      _mensagem = 'Perda de conexão com o servidor, verifique a conexão com a internet';
    }else if (erro.contains('EXPIRED_TOKEN')) {
      _mensagem = 'Autenticação expirada, realize o login novamente';
    }else if (erro.contains('INVALID_TOKEN')) {
      _mensagem = 'Token de autorização inválido';
    }else if (erro.contains('MAX_RETRIES')) {
      _mensagem = 'Máximo de tentativas de acesso alcançado';
    }else if (erro.contains('NETWORK_ERROR')) {
      _mensagem = 'Erro de rede, tente novamente mais tarde';
    }else if (erro.contains('OPERATION_FAILED')) {
      _mensagem = 'O servidor não pode executar a operação';
    }else if (erro.contains('OVERRIDDEN_BY_SET')) {
      _mensagem = 'Transação sobrescrita por outro conjunto';
    }else if (erro.contains('PERMISSION_DENIED')) {
      _mensagem = 'Permissão negada, você não pode acessar o serviço';
    }else if (erro.contains('UNAVAILABLE')) {
      _mensagem = 'Serviço indisponível';
    }else if (erro.contains('UNKNOWN_ERROR')) {
      _mensagem = 'Erro desconhecido';
    }else if (erro.contains('USER_CODE_EXCEPTION')) {
      _mensagem = 'Erro de código de usuário';
    }else if (erro.contains('WRITE_CANCELED')) {
      _mensagem = 'A escrita foi cancelada localmente';
    }
    return _mensagem;
  }
}