<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"  isELIgnored ="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>


<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Primeiro Nivel Teste</title>


    <!-- Bootstrap core CSS -->
    <link href="${BASE_FOLDER}/assets/bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="${BASE_FOLDER}/assets/css/style.css" rel="stylesheet">

    <snk:load/>

</head>


<body>

    <snk:query var="parceiros"> 
        SELECT CODPARC, NOMEPARC, SANKHYA.Formatar_Cpf_Cnpj(CGC_CPF) AS CNPJ, UPPER(SANKHYA.OPTION_LABEL('TGFPAR', 'TIPPESSOA', TIPPESSOA) ) AS TIPPESSOA FROM TGFPAR WHERE FORNECEDOR ='S' AND CODPARC BETWEEN 40 AND 45 
    </snk:query>


    <main role="main">
        <div class="table-responsive">
            <section class="text-center">
                <div class="container"><br>
                    <h5>Relação de Parceiros</h5>
                    <table class="table table-bordered table-condensed-main">
                        <thead class="thead-dark">
                        <tr>
                            <th scope="col">Cód. Parceiro</th>
                            <th scope="col">Nome Parceiro</th>
                            <th scope="col">CNPJ</th>
                            <th scope="col">Tipo de Pessoa</th>
                        </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${parceiros.rows}" var="row">
                                <tr>
                                    <th scope="row"> <c:out value="${row.CODPARC}" /></th>
                                    <td><c:out value="${row.NOMEPARC}" /></td>
                                    <td><c:out value="${row.CNPJ}" /></td>
                                    <td><c:out value="${row.TIPPESSOA}" /></td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>
            </section>
        </div>
      </main>
</body>
</html>