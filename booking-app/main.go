package main

import (
	"booking-app/helper"
	"fmt"
	"sync"
	"time"
)

var conferenceName = "Go conference"

const conferenceTickets = 50

var remainingTickets = conferenceTickets
var bookings = make([]UserData, 0)

type UserData struct {
	firstName        string
	lastName         string
	email            string
	nummberOfTickets int
}

var wg = sync.WaitGroup{}

func main() {
	greetUser()
	fmt.Println("Get your tickets to attend")

	// To define a variable
	// for {

	firstName, lastName, email, userTickets := getUserinput()

	//isInValidcity := city == "singapore" || city == "Londan"
	isValidName, isValidemail, isValiduserticket := helper.ValidateInput(firstName, lastName, email, userTickets, remainingTickets)
	if isValidName && isValidemail && isValiduserticket {

		bookTickets(remainingTickets, userTickets, firstName, lastName, email, conferenceName)
		wg.Add(1)
		go sendTickets(userTickets, firstName, lastName, email)

		//This is for slicing the first name from the complete name

		fmt.Printf("The first names of bookins are : %v\n", getFirstnames())
		if remainingTickets == 0 {
			// end the programm
			fmt.Printf("%v is booked out.Come back next year\n", conferenceName)
			//break
		}

	} else {
		if !isValidName {
			fmt.Print("Invalid username ")
		} else if !isValidemail {
			fmt.Printf("Invalid user email")
		} else if !isValiduserticket {
			fmt.Printf("number of tickets entered is invalid")
		}
	}
	wg.Wait()
}

//}

func greetUser() {
	fmt.Println("Welcome to our", conferenceName, "booking application")
	fmt.Println("We have total of ", conferenceTickets, "tickets and ", remainingTickets, "are available")

}

func getFirstnames() []string {
	firstNames := []string{}
	for _, booking := range bookings {
		//var names = strings.Fields(booking)
		firstNames = append(firstNames, booking.firstName)
	}
	return firstNames
}

func getUserinput() (string, string, string, int) {
	var firstName string
	var lastName string
	var email string
	var userTickets int
	fmt.Println("Enter your firstName:")
	fmt.Scan(&firstName)
	fmt.Println("Enter your lastName:")
	fmt.Scan(&lastName)
	fmt.Println("Enter your email:")
	fmt.Scan(&email)
	fmt.Println("Enter your yourTickets:")
	fmt.Scan(&userTickets)
	return firstName, lastName, email, userTickets
}

func bookTickets(remainingTickets int, userTickets int, firstName string, lastName string, email string, conferenceName string) {
	remainingTickets = remainingTickets - userTickets

	// Create a MAP for the user
	var userData = UserData{
		firstName:        firstName,
		lastName:         lastName,
		email:            email,
		nummberOfTickets: userTickets,
	}
	bookings = append(bookings, userData)

	fmt.Printf("Thank you %v %v for booking %v  Tickets.You will receive your confirmed tickets to your mail id %v\n", firstName, lastName, userTickets, email)
	fmt.Printf("Remaining tickets %v for %v\n", remainingTickets, conferenceName)
}

func sendTickets(userTickets int, firstName string, lastName string, email string) {
	time.Sleep(10 * time.Second)
	var ticket = fmt.Sprintf("%v tickets for %v %v", userTickets, firstName, lastName)
	fmt.Printf("***************************************************************")
	fmt.Printf("Sending tickets:\n %v to email address %v", ticket, email)
	fmt.Printf("***************************************************************")
	wg.Done()
}
