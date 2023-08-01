using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ToDoApp
{
    class Program
    {
        static List<string> taskList;

        static void Main(string[] args)
        {
            taskList = new List<string>();
            string choice;
            do
            {
                Console.WriteLine("__________________________________");
                Console.WriteLine("Choose any one operation from below : ");
                Console.WriteLine();
                Console.WriteLine("1. Create new task");
                Console.WriteLine("2. Show task list");
                Console.WriteLine("3. Edit task");
                Console.WriteLine("4. Delete task");
                Console.WriteLine("5. Exit");
                Console.WriteLine("__________________________________");
                Console.WriteLine("Enter your choice:");
                choice = Console.ReadLine();

                switch (choice)
                {
                    case "1":
                        Console.WriteLine("Enter user_id :");
                        int uid= Convert.ToInt32(Console.ReadLine());
                        DateTime date = DateTime.Now;
                        Console.WriteLine("Add new task:");
                        string task= Console.ReadLine();
                        Console.WriteLine("Enter status_is : ");
                        int sid = Convert.ToInt32(Console.ReadLine());
                        Add(uid,date,task,sid);
                        break;
                    case "2":
                        Console.WriteLine(".............................");
                        Console.WriteLine("Task List:");
                        Show(taskList);
                        Console.WriteLine(".............................");
                        break;
                    case "3":
                        Console.WriteLine("Enter task index to edit:");
                        int editValue = Convert.ToInt32(Console.ReadLine());
                        Edit(editValue);
                        break;
                    case "4":
                        Console.WriteLine("Enter task index to delete:");
                        int deleteValue = Convert.ToInt32(Console.ReadLine());
                        Delete(deleteValue);
                        break;
                    default:
                        return;
                }

            }
            while (choice != "0");
        }

        static private string GetConnectionString()
        {
            string connectionString = "Data Source=(local)\\MSSQLLocalDB;Server=DESKTOP-QKHCBTS\\SQLEXPRESS;Initial Catalog=ToDoList;"
                + "Integrated Security=True;";
            return connectionString;
        }

        static void Add(int uid, DateTime date , String task , int sid)
        {
            string connectionString = GetConnectionString();
            string insert = "Insert into task(user_id,datetime,task,status_id) values(@user_id,@date,@task,@status_id),";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand(insert, connection))
                {
                    cmd.Parameters.Add("@user_id", SqlDbType.Int).Value = uid ;
                    cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = date;
                    cmd.Parameters.Add("@task", SqlDbType.NVarChar).Value = task;
                    cmd.Parameters.Add("@status_id", SqlDbType.Int).Value = sid;
                    Console.WriteLine("Task added successfully!!");
                }
            }
        }


        static void Show(List<string> tasklist)
        {
            string connectionString = GetConnectionString();
            string select = "SELECT * FROM task;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand(select, connection))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                int id = reader.GetInt32(0);
                                int uid = reader.GetInt32(1);
                                DateTime date = reader.GetDateTime(2);
                                string task = reader.GetString(3);
                                int sid = reader.GetInt32(4);
                                Console.WriteLine($"ID: {id}, Uid : {uid} , Date : {date} , Task: {task} , Sid : {sid}");
                            }
                        }
                    }
                }
                catch (Exception)
                {
                    Console.WriteLine("Error Retriving");
                }
                }
        }

                   
        static void Edit(int indexValue)
        {
            if (indexValue != -1)
            {
                Console.WriteLine("Enter new task:");
                string newTask = Console.ReadLine();
                taskList[indexValue] = newTask;
                Console.WriteLine("Task edited successfully!!");
            }
            else
            {
                Console.WriteLine("Invalid index!");
            }
        }

        static void Delete(int indexValue)
        {
            if (indexValue != -1)
            {
                taskList.RemoveAt(indexValue);
                Console.WriteLine("Task deleted successfully!!");
            }
            else
            {
                Console.WriteLine("Invalid index!");
            }

        }

    }

}