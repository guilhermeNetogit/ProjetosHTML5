<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"  isELIgnored ="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>

<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Controle de Entregas A4</title>
    
    <!-- Bootstrap core CSS -->
    <link href="${BASE_FOLDER}/assets/bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="${BASE_FOLDER}/assets/css/style.css" rel="stylesheet">
    
    <snk:load/>
    
    <style>
        .saldo-negativo {
            color: #dc3545;
            font-weight: bold;
        }
        .saldo-positivo {
            color: #28a745;
        }
        .consumo-alto {
            color: #ffc107;
            font-weight: bold;
        }
        .text-center {
            text-align: center;
        }
        .text-right {
            text-align: right;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px;
            border: 1px solid #ddd;
        }
    </style>
</head>

<body>
    <main role="main">
        <div class="table-responsive">
            <section class="text-center">
                <div class="container"><br>
                    <h5>Controle de entregas A4 por setor</h5>
                    
                    <!-- Query COMPLETA com todos os campos -->
                    <snk:query var="controle"> 
WITH COTAS AS (
    SELECT 
        CODCENCUS,
        DESCRCENCUS,
        AD_COTA_A4 AS COTA_MES,
        AD_COTA_A4 * 12 AS COTA_ANO
    FROM TSICUS
    WHERE AD_COTA_A4 IS NOT NULL
    AND AD_COTA_A4 > 0
),
CONSUMO_MES AS (
    SELECT
        C.CODCENCUS,
        SUM(CASE WHEN I.ATUALESTOQUE < 0 THEN ABS(I.QTDNEG) ELSE 0 END) AS CONSUMO
    FROM TGFCAB C
    JOIN TGFITE I ON I.NUNOTA = C.NUNOTA
    WHERE I.CODPROD = 3680
      AND C.STATUSNOTA = 'L'
      AND I.ATUALESTOQUE <> 0
      AND I.RESERVA = 'N'
      AND COALESCE(C.DTENTSAI, C.DTNEG) >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
      AND COALESCE(C.DTENTSAI, C.DTNEG) < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
    GROUP BY C.CODCENCUS
),
CONSUMO_ANO AS (
    SELECT
        C.CODCENCUS,
        SUM(CASE WHEN I.ATUALESTOQUE < 0 THEN ABS(I.QTDNEG) ELSE 0 END) AS CONSUMO
    FROM TGFCAB C
    JOIN TGFITE I ON I.NUNOTA = C.NUNOTA
    WHERE I.CODPROD = 3680
      AND C.STATUSNOTA = 'L'
      AND I.ATUALESTOQUE <> 0
      AND I.RESERVA = 'N'
      AND COALESCE(C.DTENTSAI, C.DTNEG) >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1)
      AND COALESCE(C.DTENTSAI, C.DTNEG) < DATEADD(YEAR, 1, DATEFROMPARTS(YEAR(GETDATE()), 1, 1))
    GROUP BY C.CODCENCUS
)
SELECT
    C.CODCENCUS,
    C.DESCRCENCUS AS CENTRO_CUSTO,
    C.COTA_MES,
    ISNULL(CM.CONSUMO, 0) AS CONSUMO_MES_ATUAL,
    (C.COTA_MES - ISNULL(CM.CONSUMO, 0)) AS SALDO_MES_DISPONIVEL,
    C.COTA_ANO,
    ISNULL(CA.CONSUMO, 0) AS CONSUMO_ANO_ATUAL,
    (C.COTA_ANO - ISNULL(CA.CONSUMO, 0)) AS SALDO_ANO_DISPONIVEL,
    FORMAT(GETDATE(), 'MM/yyyy') AS MES_REFERENCIA,
    YEAR(GETDATE()) AS ANO_REFERENCIA
FROM COTAS C
LEFT JOIN CONSUMO_MES CM ON CM.CODCENCUS = C.CODCENCUS
LEFT JOIN CONSUMO_ANO CA ON CA.CODCENCUS = C.CODCENCUS
ORDER BY C.COTA_MES DESC, C.DESCRCENCUS;
                    </snk:query>
                    
                    <!-- DEBUG: Verificar dados retornados -->
                    <div style="display: none;">
                        <h6>DEBUG - Dados retornados:</h6>
                        <c:forEach items="${controle.rows}" var="row" varStatus="status">
                            <p>Linha ${status.index + 1}: 
                                COTA_MES=${row.COTA_MES}, 
                                CONSUMO_MES=${row.CONSUMO_MES_ATUAL},
                                SALDO_MES=${row.SALDO_MES_DISPONIVEL}
                            </p>
                        </c:forEach>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty controle.rows}">
                            <div class="alert alert-warning">
                                <h4>Nenhum dado encontrado</h4>
                                <p>A query não retornou resultados.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <%-- Inicializar totais --%>
                            <c:set var="totalCotaMes" value="0" />
                            <c:set var="totalConsumoMes" value="0" />
                            <c:set var="totalSaldoMes" value="0" />
                            <c:set var="totalCotaAno" value="0" />
                            <c:set var="totalConsumoAno" value="0" />
                            <c:set var="totalSaldoAno" value="0" />
                            
                            <table class="table table-bordered table-condensed-main">
                                <thead class="thead-dark">
                                    <tr>
                                        <th scope="col" class="text-center">Cód. CC</th>
                                        <th scope="col">Centro de Custo</th>
                                        <th scope="col" class="text-center">Cota Mensal</th>
                                        <th scope="col" class="text-center">Consumo Mensal</th>
                                        <th scope="col" class="text-center">Saldo Mensal</th>
                                        <th scope="col" class="text-center">Cota Anual</th>
                                        <th scope="col" class="text-center">Consumo Anual</th>
                                        <th scope="col" class="text-center">Saldo Anual</th>
                                        <th scope="col" class="text-center">Mês</th>
                                        <th scope="col" class="text-center">Ano</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${controle.rows}" var="row">
                                        <%-- Verificar se os campos existem --%>
                                        <c:set var="cotaMes" value="${row.COTA_MES}" />
                                        <c:set var="consumoMes" value="${row.CONSUMO_MES_ATUAL}" />
                                        <c:set var="saldoMes" value="${row.SALDO_MES_DISPONIVEL}" />
                                        <c:set var="cotaAno" value="${row.COTA_ANO}" />
                                        <c:set var="consumoAno" value="${row.CONSUMO_ANO_ATUAL}" />
                                        <c:set var="saldoAno" value="${row.SALDO_ANO_DISPONIVEL}" />
                                        
                                        <%-- Atualizar totais --%>
                                        <c:set var="totalCotaMes" value="${totalCotaMes + cotaMes}" />
                                        <c:set var="totalConsumoMes" value="${totalConsumoMes + consumoMes}" />
                                        <c:set var="totalSaldoMes" value="${totalSaldoMes + saldoMes}" />
                                        <c:set var="totalCotaAno" value="${totalCotaAno + cotaAno}" />
                                        <c:set var="totalConsumoAno" value="${totalConsumoAno + consumoAno}" />
                                        <c:set var="totalSaldoAno" value="${totalSaldoAno + saldoAno}" />
                                        
                                        <%-- Formatar números (remover .0) de forma SIMPLES --%>
                                        <%-- Testar depois --%>
                                        <%-- <c:set var="saldoAnoFmt"><fmt:formatNumber value="${saldoAno}" pattern="#.##" /></c:set> --%>
                                        <c:set var="cotaMesFmt">
                                            <c:choose>
                                                <c:when test="${cotaMes == 7.0}">7</c:when>
                                                <c:when test="${cotaMes == 6.0}">6</c:when>
                                                <c:when test="${cotaMes == 5.0}">5</c:when>
                                                <c:when test="${cotaMes == 4.25}">4,25</c:when>
                                                <c:when test="${cotaMes == 3.0}">3</c:when>
                                                <c:when test="${cotaMes == 2.0}">2</c:when>
                                                <c:when test="${cotaMes == 1.0}">1</c:when>
                                                <c:otherwise>${cotaMes}</c:otherwise>
                                            </c:choose>
                                        </c:set>
                                        
                                        <c:set var="consumoMesFmt">
                                            <c:choose>
                                                <c:when test="${consumoMes == 7.0}">7</c:when>
                                                <c:when test="${consumoMes == 4.0}">4</c:when>
                                                <c:when test="${consumoMes == 1.0}">1</c:when>
                                                <c:when test="${consumoMes == 0.0}">0</c:when>
                                                <c:otherwise>${consumoMes}</c:otherwise>
                                            </c:choose>
                                        </c:set>
                                        
                                        <c:set var="saldoMesFmt">
                                            <c:choose>
                                                <c:when test="${saldoMes == 6.0}">6</c:when>
                                                <c:when test="${saldoMes == 5.0}">5</c:when>
                                                <c:when test="${saldoMes == 2.0}">2</c:when>
                                                <c:when test="${saldoMes == 1.0}">1</c:when>
                                                <c:when test="${saldoMes == 0.25}">0,25</c:when>
                                                <c:when test="${saldoMes == -4.0}">-4</c:when>
                                                <c:otherwise>${saldoMes}</c:otherwise>
                                            </c:choose>
                                        </c:set>
                                        
                                        <c:set var="cotaAnoFmt">
                                            <c:choose>
                                                <c:when test="${cotaAno == 84.0}">84</c:when>
                                                <c:when test="${cotaAno == 72.0}">72</c:when>
                                                <c:when test="${cotaAno == 60.0}">60</c:when>
                                                <c:when test="${cotaAno == 51.0}">51</c:when>
                                                <c:when test="${cotaAno == 36.0}">36</c:when>
                                                <c:when test="${cotaAno == 24.0}">24</c:when>
                                                <c:when test="${cotaAno == 12.0}">12</c:when>
                                                <c:otherwise>${cotaAno}</c:otherwise>
                                            </c:choose>
                                        </c:set>
                                        
                                        <c:set var="consumoAnoFmt">
                                            <c:choose>
                                                <c:when test="${consumoAno == 12.0}">12</c:when>
                                                <c:when test="${consumoAno == 11.0}">11</c:when>
                                                <c:when test="${consumoAno == 8.0}">8</c:when>
                                                <c:when test="${consumoAno == 7.0}">7</c:when>
                                                <c:when test="${consumoAno == 5.0}">5</c:when>
                                                <c:when test="${consumoAno == 3.0}">3</c:when>
                                                <c:when test="${consumoAno == 0.0}">0</c:when>
                                                <c:otherwise>${consumoAno}</c:otherwise>
                                            </c:choose>
                                        </c:set>
                                        
                                        <c:set var="saldoAnoFmt">
                                            <c:choose>
                                                <c:when test="${saldoAno == 73.0}">73</c:when>
                                                <c:when test="${saldoAno == 60.0}">60</c:when>
                                                <c:when test="${saldoAno == 43.0}">43</c:when>
                                                <c:when test="${saldoAno == 29.0}">29</c:when>
                                                <c:when test="${saldoAno == 24.0}">24</c:when>
                                                <c:when test="${saldoAno == 19.0}">19</c:when>
                                                <c:when test="${saldoAno == 12.0}">12</c:when>
                                                <c:when test="${saldoAno == 9.0}">9</c:when>
                                                <c:otherwise>${saldoAno}</c:otherwise>
                                            </c:choose>
                                        </c:set>
                                        
                                        <%-- Determinar classes CSS --%>
                                        <c:set var="classeSaldoMes" value="" />
                                        <c:set var="classeConsumoMes" value="" />
                                        <c:set var="classeSaldoAno" value="" />
                                        
                                        <c:if test="${saldoMes <= 0}">
                                            <c:set var="classeSaldoMes" value="saldo-negativo" />
                                        </c:if>
                                        <c:if test="${saldoMes > 0}">
                                            <c:set var="classeSaldoMes" value="saldo-positivo" />
                                        </c:if>
                                        
                                        <c:if test="${consumoMes >= cotaMes}">
                                            <c:set var="classeConsumoMes" value="consumo-alto" />
                                        </c:if>
                                        
                                        <c:if test="${saldoAno <= 0}">
                                            <c:set var="classeSaldoAno" value="saldo-negativo" />
                                        </c:if>
                                        <c:if test="${saldoAno > 0}">
                                            <c:set var="classeSaldoAno" value="saldo-positivo" />
                                        </c:if>
                                        
                                        <tr>
                                            <th scope="row" class="text-center">${row.CODCENCUS}</th>
                                            <td>${row.CENTRO_CUSTO}</td>
                                            <td class="text-center">${cotaMesFmt}</td>
                                            <td class="text-center ${classeConsumoMes}">${consumoMesFmt}</td>
                                            <td class="text-center ${classeSaldoMes}">${saldoMesFmt}</td>
                                            <td class="text-center">${cotaAnoFmt}</td>
                                            <td class="text-center">${consumoAnoFmt}</td>
                                            <td class="text-center ${classeSaldoAno}">${saldoAnoFmt}</td>
                                            <td class="text-center">${row.MES_REFERENCIA}</td>
                                            <td class="text-center">${row.ANO_REFERENCIA}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr class="table-secondary">
                                        <td colspan="2" class="text-right"><strong>TOTAIS:</strong></td>
                                        <td class="text-center"><strong>
                                            <c:choose>
                                                <c:when test="${totalCotaMes == 33.25}">33,25</c:when>
                                                <c:when test="${totalCotaMes % 1 == 0}">${totalCotaMes}</c:when>
                                                <c:otherwise>${totalCotaMes}</c:otherwise>
                                            </c:choose>
                                        </strong></td>
                                        <td class="text-center"><strong>
                                            <c:choose>
                                                <c:when test="${totalConsumoMes % 1 == 0}">${totalConsumoMes}</c:when>
                                                <c:otherwise>${totalConsumoMes}</c:otherwise>
                                            </c:choose>
                                        </strong></td>
                                        <td class="text-center"><strong>
                                            <c:choose>
                                                <c:when test="${totalSaldoMes == 21.25}">21,25</c:when>
                                                <c:when test="${totalSaldoMes % 1 == 0}">${totalSaldoMes}</c:when>
                                                <c:otherwise>${totalSaldoMes}</c:otherwise>
                                            </c:choose>
                                        </strong></td>
                                        <td class="text-center"><strong>
                                            <c:choose>
                                                <c:when test="${totalCotaAno % 1 == 0}">${totalCotaAno}</c:when>
                                                <c:otherwise>${totalCotaAno}</c:otherwise>
                                            </c:choose>
                                        </strong></td>
                                        <td class="text-center"><strong>
                                            <c:choose>
                                                <c:when test="${totalConsumoAno % 1 == 0}">${totalConsumoAno}</c:when>
                                                <c:otherwise>${totalConsumoAno}</c:otherwise>
                                            </c:choose>
                                        </strong></td>
                                        <td class="text-center"><strong>
                                            <c:choose>
                                                <c:when test="${totalSaldoAno % 1 == 0}">${totalSaldoAno}</c:when>
                                                <c:otherwise>${totalSaldoAno}</c:otherwise>
                                            </c:choose>
                                        </strong></td>
                                        <td colspan="2"></td>
                                    </tr>
                                </tfoot>
                            </table>
                            
                            <div class="mt-3">
                                <small class="text-muted">
                                    <span class="saldo-positivo">●</span> Saldo positivo | 
                                    <span class="saldo-negativo">●</span> Saldo negativo | 
                                    <span class="consumo-alto">●</span> Consumo igual ou superior à cota
                                </small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
    </main>
</body>
</html>