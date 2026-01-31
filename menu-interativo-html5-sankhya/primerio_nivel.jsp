<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"  isELIgnored ="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Primeiro Nivel</title>

    <!-- Bootstrap core CSS -->
    <link href="${BASE_FOLDER}/assets/css/style.css" rel="stylesheet">

    <snk:load/>
    <script type='text/javascript'>
       function abrirEquipamentos(){openLevel('06V', {})}
       function abrirLocalizacao(){openLevel('04G', {})}    
       function abrirDefensivos(){openLevel('03F', {})}
       function abrirFertilizantes(){openLevel('03N', {})}
       function abrirHoras(){openLevel('07B', {})}
       function abrirDiesel(){openLevel('06U', {})}
       function abrirDiarias(){openLevel('04U', {})}

    </script>
</head>

<body class="principal">

    <div class="cards-list">

        <a href="https://www.gigantaolocadora.com.br/" target="_blank" class="custom-card">
            <div class="card 1">
                <div class="card_image" id="background_card_4">
                    <img src="${BASE_FOLDER}/assets/img/link.png" />
                    </div>
                <div class="card_title title-white">
                    <p>Link Externo</p>
                </div>
            </div>
        </a>


        <a href="#" onclick="javascript:abrirLocalizacao()" class="custom-card"> 
            <div class="card 1">
                <div class="card_image" id="background_card_6"> 
                     <img src="${BASE_FOLDER}/assets/img/localizacao.png" /> 
                    </div>
                <div class="card_title title-white">
                    <p></p>
                </div>
            </div>
        </a>

        <a href="#" onclick="javascript:abrirEquipamentos()" class="custom-card"> 
            <div class="card 1">
                <div class="card_image" id="background_card_5"> 
                     <img src="${BASE_FOLDER}/assets/img/gigantao.png" /> 
                    </div>
                <div class="card_title title-white">
                    <p>Equipamentos</p>
                </div>
            </div>
        </a>
    
        <a href="#" onclick="javascript:abrirDefensivos()" class="custom-card"> 
            <div class="card 1">
                <div class="card_image" id="background_card_2"> 
                     <img src="${BASE_FOLDER}/assets/img/defensivos.png" /> 
                    </div>
                <div class="card_title title-white">
                    <p>Defensivos</p>
                </div>
            </div>
        </a>

        <a href="#" onclick="javascript:abrirFertilizantes()" class="custom-card"> 
            <div class="card 1">
                <div class="card_image" id="background_card_7"> 
                     <img src="${BASE_FOLDER}/assets/img/fertilizante.png" /> 
                </div>
                <div class="card_title title-white">
                    <p>Fertilizantes</p>
                </div>
            </div>
        </a>

        <a href="#" onclick="javascript:abrirHoras()" class="custom-card"> 
            <div class="card 1">
                <div class="card_image"  id="background_card_3"> 
                    <img src="${BASE_FOLDER}/assets/img/horas.png" /> 
                </div>
                <div class="card_title title-white">
                    <p>Horas </p>
                </div>
            </div>
        </a>

       <a href="#" onclick="javascript:abrirDiesel()" class="custom-card"> 
           <div class="card 1">
               <div class="card_image"  id="background_card_2"> 
                    <img src="${BASE_FOLDER}/assets/img/diesel.png" />
                </div>
               <div class="card_title title-white">
                  <p>Diesel </p>
               </div>
           </div>
       </a>

       <a href="#" onclick="javascript:abrirDiarias()" class="custom-card"> 
            <div class="card 1">
                <div class="card_image" id="background_card_1" >  
                    <img src="${BASE_FOLDER}/assets/img/diarias.png" /> 
                </div>
                <div class="card_title title-white">
                    <p>Diarias </p>
                </div>
            </div>
        </a>
     </div>
     <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>
     <script src='https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js'></script>
</body>
</html>
