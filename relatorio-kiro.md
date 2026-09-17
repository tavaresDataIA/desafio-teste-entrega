# 🤖 Relatório de Uso de IA — Operação TechNova

> Relatório de TESTE (entrega fictícia para validar o pipeline).

## Identificação

- **Aluno:** Aluno de Teste
- **RA:** 000000
- **Ferramenta(s) de IA utilizada(s):** Kiro
- **Data de conclusão:** 16/09/2026

---

## Parte A — Estratégia Geral com a IA

### A.1 Como você dividiu o desafio para a IA não alucinar nem sobrecarregar?

Ataquei uma fase por vez e, dentro de cada fase, um erro por vez. Em vez de pedir "conserta o repositório", colava a mensagem de erro específica (do `docker build`, `terraform validate`, etc.) e pedia a causa e a correção daquela linha. Isso mantém o contexto pequeno e verificável.

### A.2 Qual foi seu "tamanho ideal de spec/prompt"?

Um problema concreto com evidência (log/arquivo) por prompt. Ex.: "o `terraform validate` retornou este erro na linha X, o que significa e como corrijo?". Prompts pequenos e com contexto real deram respostas precisas.

### A.3 Como você usou o CI/CD como bússola junto com a IA?

Cada job vermelho no CI virava o próximo prompt. Rodava `bash scripts/verificar.sh N` localmente antes de commitar e só subia quando a fase passava.

---

## Parte B — Relato Fase por Fase

### Fase 1 — Git
- **Diagnóstico:** senha hardcoded no `database.yml`, `APP_ENV` errado, sem `.gitignore`.
- **Como usei a IA:** pedi como trocar o segredo por variável de ambiente e boas práticas.
- **A IA errou/alucinou?:** sugeriu só remover do arquivo; lembrei que o histórico persiste.
- **Como validei:** `grep` da senha + `bash scripts/verificar.sh 1`.

### Fase 2 — Docker
- **Diagnóstico:** `node:latest`, COPY quebrado, roda root, sem EXPOSE, CMD errado.
- **Como usei a IA:** um erro de build por vez.
- **A IA errou/alucinou?:** não de forma relevante.
- **Como validei:** `docker build`, `docker inspect` do usuário, `curl /flag`.

### Fase 3 — Docker Compose
- **Diagnóstico:** redes separadas, faltava DB_PASSWORD, DB_HOST errado, healthcheck errado.
- **Como usei a IA:** analisei logs de `getaddrinfo` com ela.
- **A IA errou/alucinou?:** confundiu nome de serviço; corrigi com `docker compose ps`.
- **Como validei:** `docker compose up`, `curl /flag`.

### Fase 4 — Terraform / HCL
- **Diagnóstico:** faltava required_providers, var não declarada, `conteudo`, `${var::ambiente}`, output errado.
- **Como usei a IA:** cada mensagem do `validate` virou uma correção.
- **A IA errou/alucinou?:** propôs atributo inexistente uma vez; `validate` pegou.
- **Como validei:** `terraform validate` + `apply`.

### Fase 5 — VPC / Rede / Segurança
- **Diagnóstico:** banco 5432 aberto p/ 0.0.0.0/0 e faltava rota IGW.
- **Como usei a IA:** revisão de segurança do SG.
- **A IA errou/alucinou?:** não.
- **Como validei:** análise do SG + `terraform validate`.

### Fase 6 — RDS + Remote State
- **Diagnóstico:** backend sem encrypt/dynamodb; RDS público, sem encriptação, sem subnet group.
- **Como usei a IA:** dois prompts separados (RDS e backend).
- **A IA errou/alucinou?:** não.
- **Como validei:** `terraform validate -backend=false` + checagem dos atributos.

### Fase 7 — Módulos
- **Diagnóstico:** dois `local_file` duplicados no root.
- **Como usei a IA:** pedi a estrutura do módulo e como chamá-lo 2x.
- **A IA errou/alucinou?:** usou `path.module`; troquei por `path.root`.
- **Como validei:** `terraform apply` gerando os dois arquivos.

### Fase 8 — AWS Academy
- **Diagnóstico/objetivo:** subir infra real no Learner Lab e comprovar.
- **Como usei a IA:** como usar `LabRole`/`LabInstanceProfile` sem criar IAM.
- **A IA errou/alucinou?:** sugeriu criar role; o Lab não permite.
- **Como validei:** `aws sts get-caller-identity`, `terraform output`, destroy.

---

## Parte C — Reflexão Crítica

### C.1 Qual foi a pior alucinação da IA no desafio e como você a percebeu?
Sugerir criar IAM role na Fase 8, o que o Learner Lab bloqueia. Percebi pelo erro de permissão.

### C.2 Em qual fase a IA MAIS ajudou? E em qual você teve que assumir o controle?
Mais ajuda na Fase 4 (mensagens de HCL). Assumi o controle na Fase 8 (restrições do Lab).

### C.3 O que você faria diferente na próxima vez que usar IA para DevOps?
Dar sempre o log completo e validar cada passo com o comando real antes de seguir.

### C.4 Você conseguiria ter validado as respostas da IA se NÃO tivesse feito as aulas 01 a 07?
Não. Sem entender rede, Docker e Terraform, não teria como saber se a resposta estava certa.

---

## Checklist Final

- [x] Preenchi a estratégia geral (Parte A)
- [x] Relatei as 8 fases individualmente (Parte B)
- [x] Respondi a reflexão crítica (Parte C)
- [x] Meu CI está 100% verde (todas as fases + gate final)
- [x] Meu PR está aberto no repositório do desafio
