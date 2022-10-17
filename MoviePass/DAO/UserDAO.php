<?php 

    namespace DAO;
    use DAO\IUserDAO as IUserDAO;
    use Models\User as User;

    use \Exception as Exception;
    use DAO\Connection as Connection;

    class UserDAO implements IUserDAO{

        private $connection;
        private $tableUsers = "users";
        private $tablePerfilUsers = "perfilUsers";

        public function Add(User $user){
            //var_dump($user);
            //$iduser = 0;
            try
            {
                $procedure = "call CargarUserClient(:user_name,:firstName,:lastName,:dni,:email,:password);";

                $parameters["user_name"] = $user->getUserName();
                $parameters["firstName"] = $user->getFirstName();
                $parameters["lastName"] = $user->getLastName();
                $parameters["dni"] = $user->getDni();
                $parameters["email"] = $user->getEmail();
                $parameters["password"] = $user->getPassword();
                //$parameters["id_perfilUser"] =$user->getId_PerfilUser();
                //$parameters["id_rol"] =$user->getRol();

                //$parameters["id"] = $iduser;

                $this->connection = Connection::GetInstance();
                $this->connection->ExecuteNonQuery($procedure,$parameters);
                //var_dump($id);
                
                
                /*$query1 = "INSERT INTO ".$this->tablePerfilUsers."(user_name,firstName,lastName,dni) 
                VALUES (:user_name,:firstName,:lastName,:dni)";
                
                $parameters["user_name"] = $user->getUserName();
                $parameters["firstName"] = $user->getFirstName();
                $parameters["lastName"] = $user->getLastName();
                $parameters["dni"] = $user->getDni();

                $this->connection = Connection::GetInstance();
                $this->connection->ExecuteNonQuery($query1,$parameters);
                echo 'aaaa';
                $query2 = "SELECT @@identity AS id_perfil FROM ".$this->tablePerfilUsers;
                $this->connection = Connection::GetInstance();
                $id = $this->connection->Execute($query2,$parameters);
                var_dump($id);*/
                
                
                //$query2 = "SELECT * FROM ".$this->tablePerfilUsers." WHERE (email = :email)";
                
                
                /*$query = "INSERT INTO ".$this->tableUsers." (email,password,id_rol)
                VALUES (:email,:password,:id_rol)";
                
                //$parameters["id_user"]=1;
                $parameters["email"] = $user->getEmail();
                $parameters["password"] = $user->getPassword();
                //$parameters["id_perfilUser"] =$user->getId_PerfilUser();
                $parameters["id_rol"] =$user->getRol();
                

                $this->connection = Connection::GetInstance();
                $this->connection->ExecuteNonQuery($query,$parameters);*/

                
                

            }
            catch(Exception $ex)
            {
                throw $ex;
            }
        }

        public function read($email)
        {
            try {
                $user = null;

            $query = "SELECT * FROM ".$this->tableUsers." WHERE (email = :email)";

            $parameters["email"] = $email;

            $this->connection = Connection::GetInstance();

            $results=$this->connection->Execute($query, $parameters);

            foreach($results as $row)
            {
                $user = new User();
                //$user->setId_user($row["id"]);
                $user->setEmail($row["email"]);
                $user->setPassword($row["password"]);
            }
            if($user==null)
                $verific=false;
            else
                $verific=true;

                
            return $verific;
            } catch (Exception $th) {
                throw $th;
            }
            
        }
        public function GetByEmail($email)
        {
            try {
                $user = null;

            $query = "SELECT email, password,id_rol FROM ".$this->tableUsers." WHERE (email = :email)";

            $parameters["email"] = $email;

            $this->connection = Connection::GetInstance();

            $results = $this->connection->Execute($query, $parameters);

            foreach($results as $row)
            {
                $user = new User();
                //$user->setId_user($row["id"]);
                $user->setEmail($row["email"]);
                $user->setPassword($row["password"]);
                $user->setRol($row["id_rol"]);
                //echo($row["id_rol"]);
            }

            return $user;
            } catch (Exception $th) {
                throw $th;
            }

        }


    }


?>