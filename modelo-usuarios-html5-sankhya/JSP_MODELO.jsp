<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored ="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<html>
  <head>
		<snk:load/> <!-- essa tag deve ficar nesta posição -->
		<snk:query var="tableResult" dataSource="MGEDS">
         SELECT LINK
              , NVL(LINK_SITE, '#') AS LINK_SITE
              , COUNT(*) OVER () AS QTD    
           FROM AD_TSIRECRH
      </snk:query>

      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
      <style>
         .tamanho {
            width: 355px;
            height: 306px;
            overflow: hidden;
         }
         img {
            margin: auto; 
         }
         .carousel-indicators li {
            height: 10px !important;
            border-radius: 50% !important;
            width: 10px;
        }
      </style>

      <script>

         var arrayValor = '{"listaValor":[{' + '"link":"LINK","linkSite":"LINK_SITE","qtd":"QTD"}' +
         <c:forEach items="${tableResult.rows}" var="row">
            ',' + '{"link":"${row.LINK}","linkSite":"${row.LINK_SITE}", "qtd":"${row.QTD}"}' +
         </c:forEach>
         ']}';

         var arrayValorJSON = JSON.parse(arrayValor);
         function renderizaHtml() /*função que descreve  o HTML que escreve na tela*/
         {
            var qtdImg = 0;
            var li = '';
            var divImg = '';
            var linkImagem = '';

            for(let i = 1; i < arrayValorJSON.listaValor.length; i++)
            {  

              if (i == 1)
              {
                  li = '<li data-target="#carouselExampleIndicators" data-slide-to="' + qtdImg + '" class="active"></li>';
                  if (arrayValorJSON.listaValor[1].linkSite != '#') {
                     divImg = '<div class="carousel-item active"><a href="'+ arrayValorJSON.listaValor[1].linkSite + '" target="_blank"><img class="d-block w-10" src="'+ arrayValorJSON.listaValor[1].link + '"></a></div>';
                  } else {
                     divImg = '<div class="carousel-item active"><img class="d-block w-10" src="'+ arrayValorJSON.listaValor[1].link + '"></div>';
                  }
              }

              if (i > 1)
              {
                  li += '<li data-target="#carouselExampleIndicators" data-slide-to="'+ qtdImg +'"></li>';
                  if (arrayValorJSON.listaValor[i].linkSite != '#') {
                     divImg += '<div class="carousel-item"><a href="'+ arrayValorJSON.listaValor[i].linkSite + '" target="_blank"><img class="d-block w-10" src="' + arrayValorJSON.listaValor[i].link + '"></a></div>';
                  } else {
                     divImg += '<div class="carousel-item"><img class="d-block w-10" src="' + arrayValorJSON.listaValor[i].link + '"></div>';
                  }
                
              }

              qtdImg++;
            }
            document.getElementById("li").innerHTML = li;
            document.getElementById("items").innerHTML = divImg;
         }
      </script>
	</head>
	
   <body onload="renderizaHtml()">
      <center>
         <div id="carouselExampleIndicators" class="carousel slide tamanho" data-ride="carousel">
            <ol class="carousel-indicators" id="li"></ol>

            <div class="carousel-inner" id="items">

            </div>

            <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
               <span class="carousel-control-prev-icon" aria-hidden="true"></span>
               <span class="sr-only">Previous</span>
            </a>
            <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
               <span class="carousel-control-next-icon" aria-hidden="true"></span>
               <span class="sr-only">Next</span>
            </a>
         </div>
      </center>

      <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
	</body>
</html>