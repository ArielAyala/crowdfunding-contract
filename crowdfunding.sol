// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Crowfunding {

     bool isFundable;
     uint256 goalAmount; 
     uint256 totalFunded;
     address owner;
     uint256 requiredFunds;
     
     constructor(){
         goalAmount = 0;
         owner = msg.sender;
         totalFunded = 0;
         isFundable = true;
     }

     // Se valida que solo el autor pueda reaalizar ciertas operaciones en el contrato
     modifier onlyOwner{
         require(msg.sender == owner, "You need to be the owner from this contract to change the goalAmount");
         _;
     }
     
     // Se valida que el author no puede agregar fondos al proyeto
     modifier onlyOtherFunders{
         require(msg.sender != owner, "The author of the contract can't fund the project");
         _;
     }

     //Aqui ponemos la meta a recaudar,solamente el que iniciaiza el contrato puede cambiar este valor
     function setGoalAmount(uint256 amount) public onlyOwner {
         goalAmount = amount;
     }
     
     function viewGoalAmount() public view returns(uint256) {
         return goalAmount;
     }
     
     function changeProjectState(bool state) public onlyOwner {
         isFundable = state;
     }

     //Aqui inicia la funcion para fondear el proyecto
     function fundproject() public payable onlyOtherFunders {
         //Primero evaluamos si el owner del contrato mantiene abiertas las donaciones
         require(isFundable, "Owner has decided to stop this fundraising for a while. Stay tuned");

         //Comprobamos que el total que se ha fondeado sea menor a la meta
         require(totalFunded < goalAmount, "goalAmount already achieved so you are  not able to fund this anymore");

         // La persona mande un minimo, mayor que cero
         require(msg.value != uint(0), "Please add some funds to contribuite to the project");

         //Comprobamos que el valor que quiere fondear no exceda con a meta que tenemos
         require(totalFunded + msg.value <= goalAmount,"unable to add more funds, check amount remaining for our goalAmount");

         //Se actualiza el total fondeado al contrato
         totalFunded += msg.value;
     }
     //Esta funcion nos sirve para que la persona pueda ver cuanto se necesita para alcanzar la meta, asi no tendra que estar adivinando cuanto depositar maximo
     function viewRemaining() public view returns(uint256){
         uint256 remainingFunds = goalAmount - totalFunded;
         return remainingFunds;
     }
     
 }
