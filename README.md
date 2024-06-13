# SmartPark - IoT Garage System

## Index

1. [Problem](#problem)
2. [Proposed Solution](#proposed-solution)
3. [Objective](#objective)
   - [Workflow](#workflow)
   - [Project Differentiator](#project-differentiator)
   - [Views](#views)
4. [Technologies Used](#technologies-used)
5. [Contribution](#contribution)
6. [Functionality](#functionality)
7. [System Operation](#system-operation)
8. [Key Components](#key-components)
9. [Potential Problems](#potential-problems)
10. [Queries and Graphs](#queries-and-graphs)
11. [Development](#development)
    - [Programs Used](#programs-used)
    - [Docker Image Initialization](#docker-image-initialization)
    - [Backend Structure](#backend-structure)
    - [Frontend Structure](#frontend-structure)
12. [Conclusions](#conclusions)
13. [Running the Project](#running-the-project)

## Problem

The management of parking spaces in university campuses is chaotic and inefficient, leading to congestion and security issues.

## Proposed Solution

An intelligent garage system with ultrasonic sensors, keypad authentication, and a mobile app for real-time management and monitoring.

## Objective

Optimize and automate real-time parking space management, enhancing efficiency and security for users while providing statistical data for the university.

### Workflow

1. **Vehicle Detection at Entry**
2. **Vehicle Authentication**
3. **Space Assignment**
4. **Garage Access**
5. **Continuous Monitoring**
6. **User Interface**

## Project Differentiator

- Complete and Automated Integration
- Use of Modern Technologies (Raspberry Pi Pico W, Flutter, Spring Boot)
- Flexible Authentication Methods (Code and License Plate Recognition)
- Intuitive Mobile Application
- Advanced Security Measures

## Technologies Used

- **Spring Boot (Java Backend)**
- **Flutter (Frontend)**
- **PostgreSQL (Database)**
- **Python (IoT Nodes and Dashboard)**

![Tecnologias utilizadas](readme-imgs/image.png)

![Esquema de la base de datos](readme-imgs/DB.png)

### Views

1. **Login**

![alt text](readme-imgs/image-1.png)

2. **Registration** for the user and his car

![alt text](readme-imgs/image-2.png) 3. **Parkings - Available Spaces**: Parking Central

![alt text](readme-imgs/image-3.png)

4. **Space Reservation**
   You can choose one car, and the time for your reservation

![alt text](readme-imgs/image-4.png)

![alt text](readme-imgs/image-5.png)

5. **Vehicle Registration**
   You can add a vehicle

![alt text](readme-imgs/image-6.png)

6. **Python Dashboard**
   KPI's from the parking ussage and the most relevant information for an ADMIN user

![alt text](readme-imgs/image-8.png)
![alt text](readme-imgs/image-9.png)

## Contribution

- **Improved Efficiency**
- **Enhanced Security**
- **Automation and Convenience**
- **Real-Time Monitoring**
- **Resource Optimization**

## Functionality

- **Detection of Available Spaces**
- **Access Control**
- **Automatic Space Assignment**
- **Physical Access Control**
- **Monitoring and Notifications**

## System Operation

### Key Components

![alt text](readme-imgs/image-7.png)

- Raspberry Pi Pico W
- Presence Sensors
- Keypad
- Servo Motor
- Motion Sensors
- WiFi Modules
- Supabase Cloud Database

## Potential Problems

- Accuracy of Space Detection
- System Security
- Response Time
- Connectivity and Synchronization

## Queries and Graphs

- Comparison of Entry and Exit Times
- Reservation Usage
- Parking Occupancy
- Space Demand

## Development

### Programs Used

- **Flutter**: 3.19.6
- **Spring Boot**: 3.0
- **Python + MicroPython**
- **PostgreSQL**: 15.3
- **Java SDK**: 20

### Docker Image Initialization

To initialize the Docker image for the PostgreSQL database:

```bash
docker run -d --name smartpark_c -e POSTGRES_PASSWORD=12345 -e POSTGRES_USER=admin -e POSTGRES_DB=smartpark_db -p 5432:5432 postgres:15.3
```

### Backend Structure

- **Entity**: `UserEntity.java`
- **Repository**: `UserRepository.java`
- **Controller**: `UserController.java`
- **DTO**: `UserDTO.java`
- **BL**: `OrderLogic.java`
- **BD**: `MySQLDatabase.java`
- **Services**: `AuthService.java`

### Frontend Structure

- **Config**: `routes.dart`
- **Models**: `user_model.dart`
- **Providers**: `user_provider.dart`
- **Styles**: `theme.dart`
- **Services**: `api_service.dart`
- **Utils**: `constants.dart`
- **Views**: `home_screen.dart`
- **Widgets**: `custom_button.dart`

## Conclusions

The system optimizes the parking experience in university campuses using advanced technologies and secure authentication, improving efficiency and security for users and providing useful data for decision-making.

## Running the Project

1. To run the database in a Docker container, use the following command:

```bash
docker run -d --name smartpark_c -e POSTGRES_PASSWORD=12345 -e POSTGRES_USER=admin -e POSTGRES_DB=smartpark_db -p 5432:5432 postgres:15.3
```

2. Then navigate to "backend\bd\smartpark.sql" and execute the database along with the test data (INSERTS).

3. In the "backend\" directory, run Spring Boot:

```bash
mvn clean install spring-boot:run
```

4. The URLs in the Python scripts for entry_node and space_nodes should point to the backend IP address and the default port 8080 currently running on the backend.

5. Ensure firewall ports have rules to allow external connections, such as IoT nodes via WiFi to port 8080 from the backend server. The network needs a router or mobile device as a router to function correctly and serve the IoT nodes.

6. Configure secrets.py with the necessary credentials to connect to the router for proper functionality.

7. Once the IoT network connection is established, proceed with the project.
