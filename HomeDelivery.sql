use [HomeDelivery]



/*---------------------------------------*/
CREATE TABLE TiposDeServicio
(
  Id INT NOT NULL,
  Descripcion VARCHAR(20) NOT NULL,
  ConditionType VARCHAR(9) NOT NULL,
  Material VARCHAR(18) NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE Instalacion
(
  Id INT NOT NULL,
  Material VARCHAR(18) NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE TipoDeProducto
(
  Id INT NOT NULL,
  Material VARCHAR(18) NOT NULL,
  TipoDeProducto VARCHAR(5) NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE Estados
(
  Id INT NOT NULL,
  Nombre INT NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE Plantas
(
  Id INT NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE CodigosPostales
(
  Id INT NOT NULL,
  CodigoPostal INT NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE Ciudades
(
  Id INT NOT NULL,
  Nombre INT NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE SubtipoDeProducto
(
  Id INT NOT NULL,
  Material INT NOT NULL,
  SubTipoDeProducto INT NOT NULL,
  PRIMARY KEY (Id)
);

CREATE TABLE Clusters
(
  Id INT NOT NULL,
  ClusterIndicator INT NOT NULL,
  EstadoId INT NOT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY (EstadoId) REFERENCES Estados(Id)
);

CREATE TABLE PlantasToAdicionales
(
  ClusterId INT NOT NULL,
  TipoDeServicioId INT NOT NULL,
  TipoDeProductoId INT NOT NULL,
  PlantaId INT NOT NULL,
  FOREIGN KEY (ClusterId) REFERENCES Clusters(Id),
  FOREIGN KEY (TipoDeServicioId) REFERENCES TiposDeServicio(Id),
  FOREIGN KEY (TipoDeProductoId) REFERENCES TipoDeProducto(Id),
  FOREIGN KEY (PlantaId) REFERENCES Plantas(Id)
);

CREATE TABLE Municipios
(
  Id INT NOT NULL,
  Nombre INT NOT NULL,
  TransaportationZone INT NOT NULL,
  CuidadId INT NOT NULL,
  EstadoId INT NOT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY (CuidadId) REFERENCES Ciudades(Id),
  FOREIGN KEY (EstadoId) REFERENCES Estados(Id)
);

CREATE TABLE DeterminaciónDePlanta
(
  Id INT NOT NULL,
  Cedis1 INT NOT NULL,
  Cedis2 INT NOT NULL,
  Cedis3 INT NOT NULL,
  Cedis4 INT NOT NULL,
  Cedis5 INT NOT NULL,
  ClusterId INT NOT NULL,
  TipoDeProductoId INT NOT NULL,
  TipoDeServiciosId INT NOT NULL,
  FOREIGN KEY (ClusterId) REFERENCES Clusters(Id),
  FOREIGN KEY (TipoDeProductoId) REFERENCES TipoDeProducto(Id),
  FOREIGN KEY (TipoDeServiciosId) REFERENCES TiposDeServicio(Id)
);

CREATE TABLE ExcepcionesCP
(
  Id INT NOT NULL,
  TipoDeProductoId INT NOT NULL,
  CodigoPostalId INT NOT NULL,
  TipoDeServicioId INT NOT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY (TipoDeProductoId) REFERENCES TipoDeProducto(Id),
  FOREIGN KEY (CodigoPostalId) REFERENCES CodigosPostales(Id),
  FOREIGN KEY (TipoDeServicioId) REFERENCES TiposDeServicio(Id)
);

CREATE TABLE Precios
(
  Precio INT NOT NULL,
  Id INT NOT NULL,
  ClusterId INT NOT NULL,
  TipoDeProductoId INT NOT NULL,
  TipodeServicioId INT NOT NULL,
  SubtipoDeProductoId INT NOT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY (ClusterId) REFERENCES Clusters(Id),
  FOREIGN KEY (TipoDeProductoId) REFERENCES TipoDeProducto(Id),
  FOREIGN KEY (TipodeServicioId) REFERENCES TiposDeServicio(Id),
  FOREIGN KEY (SubtipoDeProductoId) REFERENCES SubtipoDeProducto(Id)
);

CREATE TABLE Cobertura
(
  Cobertura INT NOT NULL,
  SucursalId INT NOT NULL,
  Subcategoria_1 INT NOT NULL,
  Subcategoria_2 INT NOT NULL,
  Subcategoria_3 INT NOT NULL,
  Subcategoria_4 INT NOT NULL,
  Id INT NOT NULL,
  TipoDeServicioId INT NOT NULL,
  TipoDeProductoId INT NOT NULL,
  EstadoId INT NOT NULL,
  MunicipioId INT NOT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY (TipoDeServicioId) REFERENCES TiposDeServicio(Id),
  FOREIGN KEY (TipoDeProductoId) REFERENCES TipoDeProducto(Id),
  FOREIGN KEY (EstadoId) REFERENCES Estados(Id),
  FOREIGN KEY (MunicipioId) REFERENCES Municipios(Id)
);
 