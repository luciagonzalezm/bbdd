drop database if exists CADENA_SUPERMERCADOS;
create database CADENA_SUPERMERCADOS collate utf8mb4_bin;
use CADENA_SUPERMERCADOS;

create table SUPERMERCADO
(
CIF char(9) primary key,
CALLE varchar(30) not null,
NUMERO varchar(10) not null,
TELEFONO varchar(12) unique not null,
CP int not null
);

create table POBLACIONES_SUPERMERCADOS
(
CP int primary key,
POBLACION varchar(30) not null
);

create table PEDIDO
(
COD_PEDIDO int primary key,
FECHA date not null,
CIF_SUPERMERCADO char(9) not null,
CIF_PROVEEDOR char(9) not null
);

create table LINEAS
(
COD_PEDIDO int not null,
NUM_LINEA int not null,
CANTIDAD int not null,
COD_PRODUCTO int not null,
constraint LIN_PK primary key (COD_PEDIDO, NUM_LINEA)
);

create table PROVEEDOR
(
CIF char(9) primary key,
NOM_COMERCIAL varchar(50) not null,
CALLE varchar(50) not null,
NUMERO varchar(10) not null,
CP int not null,
EMAIL varchar(50),
TELEFONO char(9) unique not null,
TIPO varchar(15) not null check (TIPO in ('Local', 'Ámbito nacional'))
);

create table LOCAL
(
CIF char(9) primary key,
AREA varchar(50) not null
);

create table AMBITO_NACIONAL
(
CIF char(9) primary key,
PAIS varchar(50) not null
);

create table SUMINISTRA
(
CIF char(9) not null,
COD_PRODUCTO int not null,
constraint SUM_PK primary key (CIF, COD_PRODUCTO)
);

create table SON_SUMINISTRADOS
(
CIF char(9) not null,
COD_PRODUCTO int not null,
constraint SONSU_PK primary key (CIF, COD_PRODUCTO)
);

create table PRODUCTO
(
COD_PRODUCTO int primary key,
DESCRIPCION varchar(300),
PRECIO decimal(6,2) not null,
NUM_EXISTENCIAS int not null,
TIPO varchar(20) not null check (TIPO in ('Resto productos', 'Típico zona'))
);

create table RESTO_PRODUCTOS
(
COD_PRODUCTO int primary key
);

create table TIPICO_ZONA
(
COD_PRODUCTO int primary key,
ZONA_PROCEDENCIA varchar(50) not null,
DENOMINACION_ORIGEN char(2) not null check (DENOMINACION_ORIGEN in ('Si', 'No'))
);

create table DEPARTAMENTOS
(
COD_DEPARTAMENTO int primary key,
NOMBRE varchar(50) not null,
CIF char(9) not null
);

create table TRABAJA
(
COD_DEPARTAMENTO int not null,
NUM_EMPLEADO int not null,
constraint TRA_PK primary key (COD_DEPARTAMENTO, NUM_EMPLEADO)
);

create table EMPLEADO
(
NUM_EMPLEADO int primary key,
DNI char(9) unique not null,
NOMBRE varchar(20) not null,
APELLIDOS varchar(50) not null,
CARGO varchar(20) not null,
SALARIO_NETO decimal(8,2) not null,
DATOS_CUENTA char(30) unique not null,
DEPARTAMENTOS_TRABAJA varchar(50) not null
);

create table NOMINA
(
COD_NOMINA int primary key,
NUM_EMPLEADO int not null,
FECHA date not null,
INGRESO_TOTAL decimal(8,2) not null,
DESCUENTO_TOTAL decimal(6,2) not null
);

create table LINEA_NOMINA
(
COD_NOMINA int not null,
NUM_LINEA int not null,
CANTIDAD decimal(8,2) not null,
TIPO varchar(10) check (TIPO in ('Ingreso', 'Descuento')),
constraint LINEANOM_PK primary key (COD_NOMINA, NUM_LINEA)
);

create table DESCUENTO
(
COD_NOMINA int not null,
NUM_LINEA int not null,
BASE decimal(6,2) not null,
PORCENTAJE decimal(4,2) not null,
constraint DES_PK primary key (COD_NOMINA, NUM_LINEA)
);


-- CLAVES FORÁNEAS --


alter table SUPERMERCADO add constraint CP_FK foreign key (CP) references POBLACIONES_SUPERMERCADOS (CP) on delete restrict on update cascade;

alter table PEDIDO add constraint SUP_FK foreign key (CIF_SUPERMERCADO) references SUPERMERCADO (CIF) on delete restrict on update cascade, add constraint PRO_FK foreign key (CIF_PROVEEDOR) references PROVEEDOR (CIF)  on delete restrict on update cascade;

alter table LINEAS add constraint PED_FK foreign key (COD_PEDIDO) references PEDIDO (COD_PEDIDO) on delete restrict on update cascade, add constraint PROD_FK foreign key (COD_PRODUCTO) references PRODUCTO (COD_PRODUCTO) on delete restrict on update cascade;

alter table LOCAL add constraint PROV_FK foreign key (CIF) references PROVEEDOR (CIF) on delete restrict on update cascade;

alter table AMBITO_NACIONAL add constraint PROVE_FK foreign key (CIF) references PROVEEDOR (CIF) on delete restrict on update cascade;

alter table SUMINISTRA add constraint LOC_FK foreign key (CIF) references LOCAL (CIF) on delete restrict on update cascade, add constraint PRODU_FK foreign key (COD_PRODUCTO) references TIPICO_ZONA (COD_PRODUCTO) on delete restrict on update cascade;

alter table SON_SUMINISTRADOS add constraint NAC_FK foreign key (CIF) references AMBITO_NACIONAL (CIF) on delete restrict on update cascade, add constraint PRODUC_FK foreign key (COD_PRODUCTO) references RESTO_PRODUCTOS (COD_PRODUCTO) on delete restrict on update cascade;

alter table RESTO_PRODUCTOS add constraint PRODUCT_FK foreign key (COD_PRODUCTO) references PRODUCTO (COD_PRODUCTO) on delete restrict on update cascade;

alter table TIPICO_ZONA add constraint PRODUCTO_FK foreign key (COD_PRODUCTO) references PRODUCTO (COD_PRODUCTO) on delete restrict on update cascade;

alter table DEPARTAMENTOS add constraint SUPE_FK foreign key (CIF) references SUPERMERCADO (CIF) on delete restrict on update cascade;

alter table TRABAJA add constraint DEP_FK foreign key (COD_DEPARTAMENTO) references DEPARTAMENTOS (COD_DEPARTAMENTO) on delete restrict on update cascade, add constraint EMP_FK foreign key (NUM_EMPLEADO) references EMPLEADO (NUM_EMPLEADO) on delete restrict on update cascade;

alter table NOMINA add constraint EMPL_FK foreign key (NUM_EMPLEADO) references EMPLEADO (NUM_EMPLEADO) on delete restrict on update cascade;

alter table LINEA_NOMINA add constraint NOM_FK foreign key (COD_NOMINA) references NOMINA (COD_NOMINA) on delete restrict on update cascade;

alter table DESCUENTO add constraint NOMI_FK foreign key (COD_NOMINA, NUM_LINEA) references LINEA_NOMINA (COD_NOMINA, NUM_LINEA) on delete restrict on update cascade;


-- INSERTAR DATOS EN LAS TABLAS --


insert into POBLACIONES_SUPERMERCADOS values (10002, 'Cáceres'),
											 (10600, 'Plasencia'),
                                             (06010, 'Badajoz'),
											 (06800, 'Mérida');

insert into SUPERMERCADO values ('B10467413', 'Avenida de Antonio Hurtado', '6', '927423180', 10002),
								('B10578193', 'Avenida de Salamanca', '20', '927413457', 10600),
                                ('B06823901', 'Avenida Damián Téllez Lafuente', '5', '924013477', 06010),
                                ('B06673892', 'Calle Cardenal Molina', '7', ' 924918797', 06800);
                                										
insert into PROVEEDOR values ('B10879411', 'Chinata De Alimentacion S.L.', 'Calle Jacinto Benavente', 10, 10680, 'chinatadealimentacion@gmail.com','927404295','Local'), 
							 ('B10368120', 'Alimentacion Frialto S.L.', 'Calle Calzada Real', 2, 10671, 'frialto@telefonica.net','927415101','Local'),
                             ('A28679491', 'Galsos Distribuidores Ibericos S.A.', 'Calle Mercedes Arteaga', 15, 28019, 'info@galsosdistribuidoresibericos.es','914606291','Ámbito nacional'),
							 ('A82676501', 'Nuñez Y Marcos Distribuidores S.A.', 'Calle Parroco Don Emilio Franco', 41, 28053, 'nuñezymarcos@telefonica.net','914625678','Ámbito nacional'),
                             ('B10562387', 'Alimentacion Lateral S.L.', ' Calle Julian Besteiro', 5, 10600, 'alimentacionlateral@gmail.com','927414275','Local'), 
							 ('B10542690', 'Compañia Oleicola S Xxi S.L.', 'Calle Alemania', 9, 10600, 'info@oleicolaSXXI.com','927435178','Local'),
                             ('A00676736', 'footloose-vintage S.A.', 'Rue Du Moutier', 59, 95170, 'info@footloose-vintage.es','143521778','Ámbito nacional'),
							 ('B06345467', 'Jarole Alimentacion S.L', 'Calle Vidal Lucas Cuadrado', 22, 06009 , 'jarolealimentacion@telefonica.net','927424140','Local'),
                             ('B06342894', 'Alimentacion Servipan S.L.', 'Avenida Ricardo Carapeto Zambrano', 50, 06008 , 'info@serviplan.com','927435176','Local'),
                             ('B06245783', 'Alimentacion San Servan S.L.', ' Calle Carolina Coronado', 17, 06800, 'info@sanservan.es','924562345','Local'),
							 ('B06256784', 'Dehesa De Alimentacion Y Bebidas S.L', 'Calle Logrono', 12, 06800 , 'dehesaalimentacionybebidas@telefonica.net','924378663','Local');
                                             
insert into LOCAL values ('B10879411', 'Malpartida de Plasencia'), 
						 ('B10368120', 'Aldehuela del Jerte'),
					     ('B10562387', 'Plasencia'), 
						 ('B10542690', 'Plasencia'),
					     ('B06345467', 'Badajoz'),
					     ('B06342894', 'Badajoz'),
					     ('B06245783', 'Mérida'),
						 ('B06256784', 'Mérida');      
                         
insert into AMBITO_NACIONAL values  ('A28679491', 'España'),
									('A82676501', 'España'),
                                    ('A00676736', 'Francia');                                    

insert into PRODUCTO values (1, 'Manzana Golden Marlene', '0.49', 53, 'Resto productos'),
							(2, 'Pasta al Curry - Green Masala - 200g', '2.71', 44, 'Resto productos'),
							(3, 'La Chinata - Pimentón de la Vera - Pimentón Ahumado Dulce - 70g', '6.17', 6, 'Típico zona'),
							(4, 'Gallina Blanca - Caldo Casero de Carne - 100% natural - 1l', '7.70', 2, 'Resto productos'),
							(5, 'Knorr - Sopa De Ave Con Fideos Finos 61g - Sopa Deshidratada', '3.86', 13, 'Resto productos'),
							(6, 'Cañas con azúcar La Cacereña - 500g', '4.25', 10, 'Típico zona'),
							(7, 'Vino - Ruffino Chianti Classico', '7.55', 50, 'Resto productos'),
							(8, 'Jamón de bellota ibérico 75 % raza ibérica D.0. Dehesa de Extremadura de Monesterio – 8kg', '503.75', 18, 'Típico zona'),
							(9, 'Scottex Original Papel Higiénico - 12 Rollos', '7.35', 48, 'Resto productos'),
							(10, 'Ace WC + Tubería Gel, Fórmula Autoactiva Descalcificadora sin Lejía - 70cl', '1.75', 83, 'Resto productos'),
							(11, 'Brillante Arroz Integral - Pack de 2 x 125g - Total: 250g', '1.10', 91, 'Resto productos'),
							(12, 'Cerezas caja de 2,5Kg Calibre +28', '16.25', 20, 'Típico zona'),
							(13, 'Tomato Puree', '5.74', 37, 'Resto productos'),
							(14, 'Espárragos verdes ecológicos', '6.99', 10, 'Típico zona'),
							(15, 'Salsa - Balsamic Viniagrette', '2.02', 27, 'Resto productos'),
							(16, 'Bifrutas Zumo de Frutas Tropical - Pack de 6 x 20cl - Total: 1,2l', '1.58', 33, 'Resto productos'),
							(17, 'Vino - Vouvray Cuvee Domaine', '7.32', 30, 'Resto productos'),
							(18, 'Cabecera de lomo embuchado - 400/450 gr', '16.45', 29, 'Típico zona'),
							(19, 'Pascual Yogur Griego con Frutas del Bosque - 6 Paquetes de 4 x 125g - Total: 3kg', '14.33', 10, 'Resto productos'),
							(20, 'Aceite de Oliva Virgen Extra Garrafa', '5.95', 32, 'Típico zona'),
							(21, 'Ace Lejía - 2l', '1.55', 13, 'Resto productos'),
							(22, 'Mimosín - Intense Estallido de Pasión Suavizante Concentrado - 58 lavados - 1 Botella', '3.46', 15, 'Resto productos'),
							(23, 'Miel de Azahar - La Virgen de Extremadura - 1kg', '8.35', 6, 'Típico zona'),
							(24, 'Albal Film Transparente Corte Fácil, 20 Metros - 1 Unidad', '1.89', 20, 'Resto productos'),
							(25, 'Dodot Sensitive - Toallitas para bebé, 54 unidades', '4.80', 13, 'Resto productos'),
							(26, 'Mermelada de cereza picota - CAMPO & TIERRA DEL JERTE - 260g', '1.20', 10, 'Típico zona'),
							(27, 'Lays Patatas Fritas - 300g', '1.84', 10, 'Resto productos'),
							(28, 'Mermelada artesana ESENCIA IBERICA de picota del Valle - 270g', '2.77', 28, 'Típico zona'),
							(29, 'Oral-B Pro-Expert Protección Profesional Pasta Dentífrica - 2 x 75ml', '5.10', 32, 'Resto productos'),
							(30, 'Litoral Garbanzos De La Abuela - 440g', '1.04', 83, 'Resto productos');
                            
insert into RESTO_PRODUCTOS values (1),
								   (2),
								   (4),
							       (5),
							       (7),
							       (9),
							       (10),
							       (11),							
							       (13),
							       (15),
							       (16),
							       (17),
							       (19),
							       (21),
							       (22),
							       (24),
							       (25),
								   (27),
							       (29),
							       (30);
                            
insert into TIPICO_ZONA values (3, 'La Vera', 'Si'),
							   (6, 'Carcaboso', 'No'),
                               (8, 'Monesterio', 'Si'),
							   (12, 'Valle del Jerte', 'Si'),
							   (14, 'Valle del Ambroz', 'No'),
                               (18, 'Piornal', 'No'),
                               (20, 'Sierra de Gata', 'Si'),
                               (23, 'Herrera del Duque', 'Si'),
                               (26, 'Valle del Jerte', 'No'),
                               (28, 'Valle del Jerte', 'No');   
                               
insert into SUMINISTRA values ('B10879411', 6), 
							  ('B10368120', 3),
					          ('B10562387', 12), 
                              ('B10562387', 14),
							  ('B10542690', 26),                               
						      ('B10542690', 18),
					          ('B06345467', 8),
					          ('B06342894', 23),
					          ('B06245783', 20),
						      ('B06256784', 28);
                              
insert into SON_SUMINISTRADOS values ('A28679491', 1),
								     ('A28679491', 2),
								     ('A28679491', 4),
							         ('A28679491', 5),
							         ('A28679491', 9),
							         ('A28679491', 10),
							         ('A28679491', 11),							
							         ('A28679491', 15),
									 ('A28679491', 16),
                                     ('A82676501', 19),
							         ('A82676501', 21),
							         ('A82676501', 22),
							         ('A82676501', 24),
							         ('A82676501', 25),
								     ('A82676501', 27),
							         ('A82676501', 29),
							         ('A82676501', 30),
                                     ('A00676736', 7), 
                                     ('A00676736', 13),
									 ('A00676736', 17);                              
							
insert into PEDIDO values (1, '2019/10/26', 'B10467413', 'B10879411'), 
						  (2, '2019/11/02', 'B10467413', 'B10368120'), 
                          (3, '2019/11/30', 'B10467413', 'A28679491'), 
                          (4, '2020/01/04', 'B10467413', 'A82676501'), 
                          (5, '2019/10/05', 'B10578193', 'B10562387'), 
                          (6, '2019/10/28', 'B10578193', 'B10542690'), 
                          (7, '2019/11/07', 'B10578193', 'A28679491'), 
                          (8, '2019/11/25', 'B10578193', 'A00676736'), 
                          (9, '2019/10/30', 'B06823901', 'B06345467'), 
						  (10, '2019/11/09', 'B06823901', 'B06342894'),
                          (11, '2019/11/29', 'B06823901', 'A28679491'), 
                          (12, '2019/12/04', 'B06823901', 'A82676501'), 
                          (13, '2019/10/24', 'B06673892', 'B06245783'),
                          (14, '2019/11/08', 'B06673892', 'B06256784'),
                          (15, '2019/11/24', 'B06673892', 'A82676501'), 
                          (16, '2019/11/10', 'B06673892', 'A00676736'); 
                          
insert into LINEAS values (1, 1, 20, 6),
						  (2, 1, 10, 3),
						  (3, 1, 30, 1),
                          (3, 2, 40, 2),
                          (3, 3, 50, 4),
                          (3, 4, 15, 5),
                          (3, 5, 4, 9),
                          (4, 1, 26, 19),
						  (4, 2, 6, 21),
						  (4, 3, 17, 22),
						  (4, 4, 45, 24),
						  (4, 5, 20, 25),
						  (4, 6, 24, 27),
						  (4, 7, 28, 29),
						  (4, 8, 30, 30),
                          (5, 1, 20, 12),
                          (5, 2, 15, 14),
                          (6, 1, 20, 26),
                          (6, 2, 30, 18),                          
                          (7, 1, 20, 2),
						  (7, 2, 20, 4),
						  (7, 3, 20, 10),
						  (7, 4, 20, 11),
						  (7, 5, 20,  15),
						  (7, 6, 20, 16),
                          (8, 1, 12, 7), 
						  (8, 2, 16, 13),
						  (8, 3, 5, 17),
                          (9, 1, 10, 8),
                          (10, 1, 10, 23),  
                          (11, 1, 26, 10),
                          (11, 2, 12, 11),
                          (11, 3, 6, 15),
                          (11, 4, 30, 16),
                          (12, 1, 35, 22),
                          (12, 2, 4, 27),
                          (12, 3, 6, 29),
                          (12, 4, 20, 19),
                          (13, 1, 20, 20),
						  (14, 1, 5, 28),
                          (15, 1, 30, 19),
						  (15, 2, 10, 21),
						  (15, 3, 5, 22),
						  (15, 4, 4, 24),
						  (15, 5, 10, 25),
						  (15, 6, 15, 27),
						  (15, 7, 8, 29),
						  (15, 8, 3, 30),
                          (16, 1, 12, 7), 
						  (16, 2, 16, 13),
						  (16, 3, 5, 17);  
                          
insert into DEPARTAMENTOS values (1, 'Carnicería', 'B10467413'),
								 (2, 'Pescadería', 'B10467413'),
                                 (3, 'Panadería', 'B10467413'),
                                 (4, 'Limpieza', 'B10467413'),
                                 (5, 'Higiene', 'B10467413'),
                                 (6, 'Frutería', 'B10467413'),
                                 (7, 'Caja', 'B10467413'),
                                 (8, 'Carnicería', 'B10578193'),
                                 (9, 'Panadería', 'B10578193'),
                                 (10, 'Limpieza', 'B10578193'),
                                 (11, 'Higiene', 'B10578193'),
                                 (12, 'Frutería', 'B10578193'),
                                 (13, 'Caja', 'B10578193'),
                                 (14, 'Carnicería', 'B06823901'),
								 (15, 'Pescadería', 'B06823901'),
                                 (16, 'Panadería', 'B06823901'),
                                 (17, 'Limpieza', 'B06823901'),
                                 (18, 'Higiene', 'B06823901'),
                                 (19, 'Frutería', 'B06823901'),
                                 (20, 'Caja', 'B06823901'),
                                 (21, 'Carnicería y pescadería', 'B06673892'),
                                 (22, 'Panadería', 'B06673892'),
                                 (23, 'Limpieza', 'B06673892'),
                                 (24, 'Higiene', 'B06673892'),
                                 (25, 'Frutería', 'B06673892'),
                                 (26, 'Caja', 'B06673892');
                                 
insert into EMPLEADO values (1, '76137836Q', 'Antonio', 'García Lopéz', 'Carnicero', '975.50', 'ES7645347856872357890246', 'Carnicería'),
							(2, '76137937W', 'Álvaro', 'Lopéz González', 'Panadero', '995.75', 'ES7645347856872350890230', 'Panadería'),
							(3, '67738923J', 'Juán', 'González Rovira', 'Pescadero', '1100.50', 'ES6745347056872357890230', 'Pescadería'),
							(4, '58095767K', 'José', 'González Ramos', 'Reponedor', '1000.50', 'ES6745347856872357890230', 'Limpieza'),
							(5, '76887867V', 'Vicente', 'Martín Santos', 'Reponedor', '1000.50', 'ES6745987856872357890230', 'Higiene'),
							(6, '45688902M', 'Luis', 'Romero Iglesias', 'Reponedor', '1000.50', 'ES6745347850072357890230', 'Frutería'),
							(7, '35679823S', 'Cristina', 'López Iglesias', 'Cajero', '1250.00', 'ES6745007856872997890230', 'Caja'),
							(8, '76137838H', 'Sandra', 'Tena Irala', 'Cajero', '1250.00', 'ES6745547856072097800239', 'Caja'),
							(9, '76892837L', 'Eva', 'Martín Martín', 'Carnicero', '975.50', 'ES1234547856072097800230', 'Carnicería'),
							(10, '12347890H', 'Carlos', 'Nuñéz Antón', 'Panadero', '995.75', 'ES9805547856072097800230', 'Panadería'),
							(11, '89456734M', 'Ramón', 'Pérez Sánchez', 'Reponedor', '1000.50', 'ES6745340056872357890230', 'Limpieza'),
							(12, '37890298Y', 'Juán', 'Martín Trejo', 'Reponedor', '1000.50', 'ES5745987800872357890230', 'Higiene'),
							(13, '67890453L', 'Ángel', 'García Linio', 'Reponedor', '1000.50', 'ES9045347850072357894567', 'Frutería'),
							(14, '76541287R', 'Leticia', 'López Fraile', 'Cajero', '1250.00', 'ES4545007880872997890230', 'Caja'),
							(15, '78963210R', 'Luis', 'García Antón', 'Carnicero', '975.50', 'ES1234347856872357890246', 'Carnicería'),
							(16, '07854578D', 'Marta', 'Lopéz Martín', 'Panadero', '995.75', 'ES709847856872357890230', 'Panadería'),
							(17, '68948798L', 'Enrique', 'García López', 'Reponedor', '1000.50', 'ES1235347856872877890230', 'Limpieza'),
							(18, '76879809D', 'Pepe', 'Martín Sánchez', 'Reponedor', '1000.50', 'ES1234587856872357890230', 'Higiene'),
							(19, '79813423L', 'Alicia', 'García Caballero', 'Reponedor', '1000.50', 'ES3467347850072567890230', 'Frutería'),
							(20, '78123456T', 'Bea', 'Martín Muñóz', 'Cajero', '1250.00', 'ES4567007856872007890224', 'Caja'),
							(21, '98129020A', 'Francisco', 'Álvarez García', 'Carnicero', '975.50', 'ES4567347850072357890246', 'Carnicería y pescadería'),
							(22, '45678901G', 'Damián', 'Velarde González', 'Panadero', '995.75', 'ES7645300856872300890230', 'Panadería'),
							(23, '12890020S', 'Santiago', 'Márquez Durán', 'Pescadero', '1100.50', 'ES3451347856872357000230', 'Carnicería y pescadería'),
							(24, '07761378M', 'Rodrigo', 'González Martín', 'Reponedor', '1000.50', 'ES6745340056872300890230', 'Limpieza'),
							(25, '23458900G', 'Antonio', 'Rey Santos', 'Reponedor', '1000.50', 'ES44745987856800357890230', 'Higiene'),
							(26, '45678902M', 'Blanca', 'Batuecas Iglesias', 'Reponedor', '1000.50', 'ES9245347850072357890200', 'Frutería'),
							(27, '65137891M', 'Manuel', 'Fernández López', 'Cajero', '1250.00', 'ES2445007856872557890230', 'Caja'),
							(28, '45870012P', 'Héctor', 'Gómez Sánchez', 'Cajero', '1250.00', 'ES4945547856882097830245', 'Caja');
                             
insert into TRABAJA values (1, 1),
						   (2, 2),
                           (3, 3),
                           (4, 4),
                           (5, 5),
                           (6, 6),
                           (7, 7),
                           (7, 8),
                           (8, 9),
                           (9, 10),
                           (10, 11),
                           (11, 12),
                           (12, 13),
                           (13, 14),
                           (14, 15),
                           (16, 16),
                           (17, 17),
                           (18, 18),
                           (19, 19),
                           (20, 20),
                           (21, 21),
                           (22, 22),
                           (21, 23),
                           (23, 24),
                           (24, 25),
                           (25, 26),
                           (26, 27),
                           (26, 28);
                           
insert into NOMINA values (1, 1, '2020/03/31', '975.50', '244.12'),
						  (2, 2, '2020/03/31', '995.75', '150.58'),
                          (3, 3, '2020/03/31', '1100.50', '298.75'),
                          (4, 4, '2020/03/31', '1000.50', '256.89'),
                          (5, 5, '2020/03/31', '1000.50', '256.89'),
                          (6, 6, '2020/03/31', '1000.50', '256.89'),
                          (7, 7, '2020/03/31', '1250.00', '305.20'),
                          (8, 8, '2020/03/31', '1250.00', '305.20'),
                          (9, 9, '2020/03/31', '975.50', '244.12'),
                          (10, 10, '2020/03/31', '995.75', '150.58'),
                          (11, 11, '2020/03/31', '1000.50', '256.89'),
                          (12, 12, '2020/03/31', '1000.50', '256.89'),
                          (13, 13, '2020/03/31', '1000.50', '256.89'),
                          (14, 14, '2020/03/31', '1250.00', '305.20'),
                          (15, 15, '2020/03/31', '975.50', '244.12'),
                          (16, 16, '2020/03/31', '995.75', '150.58'),
                          (17, 17, '2020/03/31', '1000.50', '256.89'),
                          (18, 18, '2020/03/31', '1000.50', '256.89'),
                          (19, 19, '2020/03/31', '1000.50', '256.89'),
                          (20, 20, '2020/03/31', '1250.00', '305.20'),
                          (21, 21, '2020/03/31', '975.50', '244.12'),
                          (22, 22, '2020/03/31', '995.75', '150.58'),
                          (23, 23, '2020/03/31', '1100.50', '298.75'),
                          (24, 24, '2020/03/31', '1000.50', '256.89'),
                          (25, 25, '2020/03/31', '1000.50', '256.89'),
                          (26, 26, '2020/03/31', '1000.50', '256.89'),
                          (27, 27, '2020/03/31', '1250.00', '305.20'),
                          (28, 28, '2020/03/31', '1250.00', '305.20');            
                          
insert into LINEA_NOMINA values (1, 1, '975.50', 'Ingreso'),
							    (1, 2, '244.12', 'Descuento'),
                                (2, 1, '995.75', 'Ingreso'),
							    (2, 2, '150.58', 'Descuento'),
                                (3, 1, '1100.50', 'Ingreso'),
							    (3, 2, '298.75', 'Descuento'),
                                (4, 1, '1000.50', 'Ingreso'),
							    (4, 2, '256.89', 'Descuento'),
                                (5, 1, '1000.50', 'Ingreso'),
							    (5, 2, '256.89', 'Descuento'),
                                (6, 1, '1000.50', 'Ingreso'),
							    (6, 2, '256.89', 'Descuento'),
                                (7, 1, '1250.00', 'Ingreso'),
							    (7, 2, '305.20', 'Descuento'),
                                (8, 1, '1250.00', 'Ingreso'),
							    (8, 2, '305.20', 'Descuento'),
                                (9, 1, '975.50', 'Ingreso'),
							    (9, 2, '244.12', 'Descuento'),
								(10, 1, '995.75', 'Ingreso'),
							    (10, 2, '150.58', 'Descuento'),
                                (11, 1, '1000.50', 'Ingreso'),
							    (11, 2, '256.89', 'Descuento'),
                                (12, 1, '1000.50', 'Ingreso'),
							    (12, 2, '256.89', 'Descuento'),
                                (13, 1, '1000.50', 'Ingreso'),
							    (13, 2, '256.89', 'Descuento'),
                                (14, 1, '1250.00', 'Ingreso'),
							    (14, 2, '305.20', 'Descuento'),
                                (15, 1, '975.50', 'Ingreso'),
							    (15, 2, '244.12', 'Descuento'),
								(16, 1, '995.75', 'Ingreso'),
							    (16, 2, '150.58', 'Descuento'),
								(17, 1, '1000.50', 'Ingreso'),
							    (17, 2, '256.89', 'Descuento'),
                                (18, 1, '1000.50', 'Ingreso'),
							    (18, 2, '256.89', 'Descuento'),
                                (19, 1, '1000.50', 'Ingreso'),
							    (19, 2, '256.89', 'Descuento'),
                                (20, 1, '1250.00', 'Ingreso'),
							    (20, 2, '305.20', 'Descuento'),
                                (21, 1, '975.50', 'Ingreso'),
							    (21, 2, '244.12', 'Descuento'),
								(22, 1, '995.75', 'Ingreso'),
							    (22, 2, '150.58', 'Descuento'),
                                (23, 1, '1100.50', 'Ingreso'),
							    (23, 2, '298.75', 'Descuento'),
                                (24, 1, '1000.50', 'Ingreso'),
							    (24, 2, '256.89', 'Descuento'),
                                (25, 1, '1000.50', 'Ingreso'),
							    (25, 2, '256.89', 'Descuento'),
                                (26, 1, '1000.50', 'Ingreso'),
							    (26, 2, '256.89', 'Descuento'),
                                (27, 1, '1250.00', 'Ingreso'),
							    (27, 2, '305.20', 'Descuento'),
                                (28, 1, '1250.00', 'Ingreso'),
							    (28, 2, '305.20', 'Descuento');
                                
insert into DESCUENTO values (1, 2, '1220.35', '25.10'),
							 (2, 2, '1147.10', '15.20'),
                             (3, 2, '1400.38', '27.25'),
                             (4, 2, '1255.12', '25.45'),
                             (5, 2, '1255.12', '25.45'),
                             (6, 2, '1255.12', '25.45'),
                             (7, 2, '1555.62', '24.45'),
                             (8, 2, '1555.62', '24.45'),
                             (9, 2, '1220.35', '25.10'),
                             (10, 2, '1147.10', '15.20'),
                             (11, 2, '1255.12', '25.45'),
                             (12, 2, '1255.12', '25.45'),
                             (13, 2, '1255.12', '25.45'),
                             (14, 2, '1555.62', '24.45'),
                             (15, 2, '1220.35', '25.10'),
                             (16, 2, '1147.10', '15.20'),
                             (17, 2, '1255.12', '25.45'),
                             (18, 2, '1255.12', '25.45'),
                             (19, 2, '1255.12', '25.45'),
                             (20, 2, '1555.62', '24.45'),
                             (21, 2, '1220.35', '25.10'),
							 (22, 2, '1147.10', '15.20'),
                             (23, 2, '1400.38', '27.25'),
                             (24, 2, '1255.12', '25.45'),
                             (25, 2, '1255.12', '25.45'),
                             (26, 2, '1255.12', '25.45'),
                             (27, 2, '1555.62', '24.45'),
                             (28, 2, '1555.62', '24.45');
                           
                           
-- CONSULTAS MULTITABLA --


-- 1. Listar el NUM_EMPLEADO, DNI, NOMBRE y APELLIDOS de los empleados y, para cada uno de ellos, los datos del departamento donde trabaja, ordenando el resultado por NUM_EMPLEADO ascendente y además por CIF, también ascendente.

select EMPLEADO.NUM_EMPLEADO, EMPLEADO.DNI, EMPLEADO.NOMBRE, EMPLEADO.APELLIDOS, DEPARTAMENTOS.* from EMPLEADO inner join TRABAJA using(NUM_EMPLEADO) inner join DEPARTAMENTOS using(COD_DEPARTAMENTO) order by EMPLEADO.NUM_EMPLEADO, DEPARTAMENTOS.CIF;                          

-- 2. Mostrar un listado del CIF y el CP de los supermercados que han realizado pedidos, indicando para cada pedido el COD_PEDIDO, la FECHA, el CIF y el NOMBRE del proveedor. Ordenando el resultado por CIF del supermercado, COD_PEDIDO y FECHA.

select SUPERMERCADO.CIF as "CIF SUPERMERCADO", SUPERMERCADO.CP as "CP SUPERMERCADO", PEDIDO.COD_PEDIDO, PEDIDO.FECHA, PROVEEDOR.CIF as "CIF PROVEEDOR", PROVEEDOR.NOM_COMERCIAL as "NOMBRE PROVEEDOR" from SUPERMERCADO inner join PEDIDO on SUPERMERCADO.CIF=PEDIDO.CIF_SUPERMERCADO inner join PROVEEDOR on PEDIDO.CIF_PROVEEDOR=PROVEEDOR.CIF order by SUPERMERCADO.CIF, PEDIDO.COD_PEDIDO, PEDIDO.FECHA;

-- 3. Listar los proveedores locales, indicando para cada uno de ellos su CIF, NOM_COMERCIAL y AREA, así como los datos de los productos que suministra, ordenando el resultado por CIF del proveedor.

select PROVEEDOR.CIF, PROVEEDOR.NOM_COMERCIAL, LOCAL.AREA, PRODUCTO.* from PROVEEDOR inner join LOCAL using(CIF) inner join SUMINISTRA using(CIF) inner join TIPICO_ZONA using(COD_PRODUCTO) inner join PRODUCTO using(COD_PRODUCTO) order by PROVEEDOR.CIF;

-- 4. Listar los proveedores nacionales, indicando para cada uno de ellos su CIF, NOM_COMERCIAL y PAIS, así como los datos de los productos que suministra, ordenando el resultado por CIF del proveedor.

select PROVEEDOR.CIF, PROVEEDOR.NOM_COMERCIAL, AMBITO_NACIONAL.PAIS, PRODUCTO.* from PROVEEDOR inner join AMBITO_NACIONAL using(CIF) inner join SON_SUMINISTRADOS using(CIF) inner join RESTO_PRODUCTOS using(COD_PRODUCTO) inner join PRODUCTO using(COD_PRODUCTO) order by PROVEEDOR.CIF;

-- 5. Mostrar un listado con los datos de los pedidos, indicando para cada línea de pedido, el NUM_LINEA, la CANTIDAD, el COD_PRODUCTO, la DESCRIPCIÓN y el PRECIO. El resultado se ordena por COD_PEDIDO, NUM_LINEA y FECHA.

select PEDIDO.*, LINEAS.NUM_LINEA, LINEAS.CANTIDAD, PRODUCTO.COD_PRODUCTO, PRODUCTO.DESCRIPCION, PRODUCTO.PRECIO from PEDIDO inner join LINEAS using(COD_PEDIDO) inner join PRODUCTO using(COD_PRODUCTO) order by PEDIDO.COD_PEDIDO, LINEAS.NUM_LINEA, PEDIDO.FECHA;


--  CONSULTAS DE RESUMEN DE DATOS -- 


-- 6. Calcular el número de departamentos que tiene cada supermercado, ordenando el resultado por el CIF del supermercado.

select CIF, count(COD_DEPARTAMENTO) as "NUMERO DEPARTAMENTOS" from DEPARTAMENTOS group by CIF order by CIF;

-- 7. Listar para cada pedido el COD_PEDIDO, el CIF_SUPERMERCADO, la FECHA, la cantidad de líneas que tiene y la cantidad total de productos pedida.
 
select PEDIDO.COD_PEDIDO, PEDIDO.CIF_SUPERMERCADO, PEDIDO.FECHA, count(LINEAS.NUM_LINEA) as "NUMERO LINEAS PEDIDO", sum(LINEAS.CANTIDAD) as "CANTIDAD PRODUCTOS PEDIDA" from PEDIDO inner join LINEAS using(COD_PEDIDO) group by PEDIDO.COD_PEDIDO;

-- 8. Contar el número de productos cuyo TIPO es 'Típico zona' y su NUM_EXISTENCIAS es mayor que 10.

select count(COD_PRODUCTO) as "NUMERO PRODUCTOS" from PRODUCTO where TIPO = 'Típico zona' and NUM_EXISTENCIAS > 10; 

-- 9. Calcular el precio medio y el número de existencias totales de cada TIPO de producto.

select TIPO, round(avg(PRECIO),2) as "PRECIO MEDIO", sum(NUM_EXISTENCIAS) as "EXISTENCIAS TOTALES" from PRODUCTO group by TIPO;

-- 10. Mostrar el NOMBRE del DEPARTAMENTO y el número de empleados que trabaja en cada DEPARTAMENTO cuyo CIF es 'B06673892' y tienen más de 1 empleado.

select DEPARTAMENTOS.NOMBRE, count(EMPLEADO.NUM_EMPLEADO) as "NUMERO EMPLEADOS" from DEPARTAMENTOS inner join TRABAJA using(COD_DEPARTAMENTO) inner join EMPLEADO using(NUM_EMPLEADO) where DEPARTAMENTOS.CIF = 'B06673892' group by DEPARTAMENTOS.NOMBRE having count(EMPLEADO.NUM_EMPLEADO) > 1;


-- SUBCONSULTAS -- 


-- 11. Mostrar los datos de los productos cuyo número de existencias sea el mayor.

select * from PRODUCTO where NUM_EXISTENCIAS = (select max(NUM_EXISTENCIAS) from PRODUCTO);

-- 12. Listar los datos de los proveedores cuyo CP sea igual al CP del PROVEEDOR con CIF 'B06245783'.

select * from PROVEEDOR where CP=(select CP from PROVEEDOR where CIF='B06245783') and CIF!='B06245783';	

-- 13. Contar el número de proveedores locales que suministran algún producto.

select count(CIF) as "Nº TOTAL PROVEEDORES LOCALES" from LOCAL where exists (select CIF from SUMINISTRA where LOCAL.CIF=SUMINISTRA.CIF);

-- 14. Listar los datos de los pedidos de los cuales la cantidad que se ha pedido en cualquiera de sus líneas no sea mayor que 10.

select * from PEDIDO where not exists (select * from LINEAS where PEDIDO.COD_PEDIDO = LINEAS.COD_PEDIDO and CANTIDAD > 10);

-- 15. Listar los datos de los empleados cuyo cargo sea el mismo que el cargo del empleado con NOMBRE 'Francisco' y APELLIDOS 'Álvarez García'.

select * from EMPLEADO where CARGO = (select CARGO from EMPLEADO where NOMBRE='Francisco' and APELLIDOS= 'Álvarez García') and NOMBRE!='Francisco' and APELLIDOS!='Álvarez García';	


-- PROCEDIMIENTOS ALMACENADOS --


-- 16. Procedimiento almacenado que muestra los empleados que trabajan en cada supermercado según el CIF del supermercado que recibe como parámetro.

delimiter //
drop procedure if exists procedure1 //
create procedure procedure1(in v_cif_supermercado char(9))
begin
	case v_cif_supermercado
		when 'B10467413' then
			select EMPLEADO.* from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B10467413';
		when 'B10578193' then
			select EMPLEADO.* from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B10578193';
		when 'B06823901' then
			select EMPLEADO.* from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B06823901';
		when 'B06673892' then
			select EMPLEADO.* from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B06673892';
		else
			select 'No existe ningún supermercado con ese CIF' as MENSAJE;
		end case;	 
end; //
delimiter ;

call procedure1('B10467413');
call procedure1('B10578193');
call procedure1('B06823901');
call procedure1('B06673892');
call procedure1('B07673800');

-- 17. Procedimiento para añadir un nuevo registro a la tabla DEPARTAMENTOS haciendo el tratamiento de errores utilizando handler.

delimiter //
drop procedure if exists procedure2//
create procedure procedure2(in v_cod_departamento int, in v_nombre varchar(50), in v_cif_supermercado char(9))
begin 
	   declare error1 boolean default false;
       declare error2 boolean default false;
       declare error3 boolean default false;
       declare continue handler for 1146 
			begin
				set error1 = true; 
			end;
		declare continue handler for sqlstate '23000'
			begin
				set error2 = true; 
			end;
		declare continue handler for 1452 
			begin
				set error3 = true; 
			end;
    insert into DEPARTAMENTOS values (v_cod_departamento, v_nombre, v_cif_supermercado);
		if error1 then
			select 'La tabla DEPARTAMENTOS no exite en la base de datos' as MENSAJE;
		else
			if error2 then
				select 'Código de departamento duplicado' as MENSAJE;
            else
				if error3 then
					select 'No existe ningún supermercado con ese CIF' as MENSAJE;
				else
					select 'Fila añadida' as MENSAJE;
                end if;
            end if;
		end if;
end; //
delimiter ;

call procedure2(1, 'Carnicería', 'B10467413');
call procedure2(60, 'Carnicería', 'B00467493');

-- 18. Procedimiento que muestra para cada supermercado, el nombre, los apellidos y el salario de los 3 empleados con mayor salario. Se utiliza un cursor que recorre los distintos supermercados que aparecen en la tabla SUPERMERCADOS. Además, para que el procedimiento muestre en una sola ventana el resultado de todos los supermercados, se crea una tabla dentro del procedimiento para guardar los resultados obtenidos de cada uno.

delimiter //
drop procedure if exists cursor1_sp//
create procedure cursor1_sp()
begin
		declare fintabla int default 0;
        declare cif_supermercado char(9);
        declare c cursor for select distinct CIF from SUPERMERCADO;
        declare continue handler for not found set fintabla=1;
        create table if not exists EMPLEADOSMAYORSALARIO (MENSAJE varchar(255));
        delete from EMPLEADOSMAYORSALARIO;
        open c;
        repeat
				fetch c into cif_supermercado;
                if not fintabla then
                insert into EMPLEADOSMAYORSALARIO select concat('Empleados con mayor salario del supermercado con CIF ', cif_supermercado);
                insert into EMPLEADOSMAYORSALARIO select '______________________________________________________';
                insert into EMPLEADOSMAYORSALARIO select concat(concat_ws(' ',EMPLEADO.NOMBRE, EMPLEADO.APELLIDOS, 'con un salario de', EMPLEADO.SALARIO_NETO,'euros')) from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = cif_supermercado order by SUPERMERCADO.CIF, EMPLEADO.SALARIO_NETO desc limit 3;
                insert into EMPLEADOSMAYORSALARIO select '______________________________________________________';
				end if;
		until fintabla
        end repeat;
        close c;
end; //
delimiter ;

call cursor1_sp();
select * from EMPLEADOSMAYORSALARIO;


-- FUNCIONES ALMACENADAS --


set global log_bin_trust_function_creators = 1;

-- 19. Función que calcula la media de salarios de los empleados de cada supermercado y retorna un mensaje diciendo cual es el supermercado con mayor media de salarios.

delimiter //
drop function if exists funcion1 //
create function funcion1()
returns varchar(200)
begin
	declare v_media_supermercado1 decimal (7,2);
    declare v_media_supermercado2 decimal (7,2);
    declare v_media_supermercado3 decimal (7,2);
    declare v_media_supermercado4 decimal (7,2);
    declare v_mensaje varchar(200);
    select round(avg(EMPLEADO.SALARIO_NETO), 2) into v_media_supermercado1 from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B10467413';
    select round(avg(EMPLEADO.SALARIO_NETO), 2) into v_media_supermercado2 from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B10578193';
    select round(avg(EMPLEADO.SALARIO_NETO), 2) into v_media_supermercado3 from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B06823901';
    select round(avg(EMPLEADO.SALARIO_NETO), 2) into v_media_supermercado4 from EMPLEADO inner join TRABAJA using (NUM_EMPLEADO) inner join DEPARTAMENTOS using (COD_DEPARTAMENTO) inner join SUPERMERCADO using(CIF) where SUPERMERCADO.CIF = 'B06673892';
    if ((v_media_supermercado1 > v_media_supermercado2) and (v_media_supermercado1 > v_media_supermercado3) and (v_media_supermercado1 > v_media_supermercado4)) then
		select concat_ws(' ', 'Los empleados del supermercado con CIF B10467413 son los que tienen un salario mayor, con una media de', v_media_supermercado1, 'euros') into v_mensaje;
	else
		if ((v_media_supermercado2 > v_media_supermercado1) and (v_media_supermercado2 > v_media_supermercado3) and (v_media_supermercado2 > v_media_supermercado4)) then
			select concat_ws(' ', 'Los empleados del supermercado con CIF B10578193 son los que tienen un salario mayor, con una media de', v_media_supermercado2, 'euros') into v_mensaje;
		else
			if ((v_media_supermercado3 > v_media_supermercado1) and (v_media_supermercado3 > v_media_supermercado2) and (v_media_supermercado3 > v_media_supermercado4)) then
				select concat_ws(' ', 'Los empleados del supercercado con CIF B06823901 son los que tienen un salario mayor, con una media de', v_media_supermercado3, 'euros') into v_mensaje;
			else
				select concat_ws(' ', 'Los empleados del supermercado con CIF B06673892 son los que tienen un salario mayor, con una media de', v_media_supermercado4, 'euros') into v_mensaje;
			end if;
		end if;
	end if;
    return v_mensaje;
end; //
delimiter ;

select funcion1() as MENSAJE;

-- 20. Función que calcula la cantidad que pide un supermercado de un producto y, si esta es mayor que 0, calcula el stock del producto que tendrá ese supermercado cuando se reciba el pedido. Si no se ha pedido ese producto, se muestra un mensaje indicándolo.

delimiter //
drop function if exists funcion2//
create function funcion2(v_cif_supermercado char(9), v_cod_producto int)
returns varchar(200)
begin
    declare v_num_existencias int;
    declare v_cantidad_pedida int default 0;
    declare v_stock int;
    declare v_mensaje varchar(200);
    select NUM_EXISTENCIAS into v_num_existencias from PRODUCTO where COD_PRODUCTO = v_cod_producto;
	select sum(LINEAS.CANTIDAD) into v_cantidad_pedida from LINEAS inner join PEDIDO using(COD_PEDIDO) where PEDIDO.CIF_SUPERMERCADO =v_cif_supermercado and LINEAS.COD_PRODUCTO = v_cod_producto;
    if (v_cantidad_pedida > 0) then
		set v_stock = v_num_existencias + v_cantidad_pedida;
		select concat_ws(' ','Cuando se reciba el pedido, el número de existencias del producto', v_cod_producto, 'del supermercado con CIF', v_cif_supermercado, 'será:', v_stock) into v_mensaje;
	else
		select 'No se ha realizado ningún pedido de ese producto' into v_mensaje;
	end if;
    return v_mensaje;
end; //
delimiter ;
 
select funcion2('B10467413', 6) as MENSAJE;
select funcion2('B10467413', 12) as MENSAJE;

-- TRIGGERS --


-- 21. Trigger para mantener sincronizada una copia de seguridad de los nuevos pedidos realizados.

create table REPLICA_PEDIDO
(
COD_PEDIDO int primary key,
FECHA date not null,
CIF_SUPERMERCADO char(9) not null,
CIF_PROVEEDOR char(9) not null
);

delimiter //
drop trigger if exists trigger1//
create trigger trigger1
before insert on PEDIDO
for each row 
begin 
	insert into REPLICA_PEDIDO values (NEW.COD_PEDIDO, NEW.FECHA, NEW.CIF_SUPERMERCADO, NEW.CIF_PROVEEDOR);
end; //
delimiter ;

insert into PEDIDO values (17, '2020/05/18', 'B06673892', 'A00676736'); 
select * from PEDIDO;
select * from REPLICA_PEDIDO;

-- 22. Trigger de auditoría que almacena en la tabla auxiliar NUEVOS_EMPLEADOS, el usuario que da de alta, la fecha y los datos que se indican a continuación de los nuevos empleados que se den de alta en nuestra BD. 

create table NUEVOS_EMPLEADOS 
(
NUM_REGISTRO int primary key auto_increment,
REGISTRO varchar(400)
);

delimiter //
drop trigger if exists trigger2//
create trigger trigger2
after insert on EMPLEADO
for each row 
begin 
	insert into NUEVOS_EMPLEADOS(REGISTRO) values (concat_ws(' ','- ALTA REALIZADA POR:',USER(),'- FECHA:', current_Date(),'- NUEVO EMPLEADO:', 'Num', NEW.NUM_EMPLEADO, 'Nombre', NEW.NOMBRE, NEW.APELLIDOS, 'Cargo' ,NEW.CARGO, 'Departamentos en los que trabaja', NEW.DEPARTAMENTOS_TRABAJA));
end; //
delimiter ;

insert into EMPLEADO values (29, '75871012D', 'Marcos', 'Sánchez Antón', 'Cajero', '1250.00', 'ES6945547856882007830240', 'Caja');
select * from EMPLEADO;
select * from NUEVOS_EMPLEADOS;
