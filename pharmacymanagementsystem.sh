#!/bin/bash

# Admin credentials (hardcoded for simplicity)
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="admin123"

# File to store pharmacists' data
PHARMACISTS_FILE="pharmacists.txt"
# File to store medicines' data
MEDICINES_FILE="medicines.txt"
# File to store customer transactions
CUSTOMERS_FILE="customers.txt"

# Ensure files exist
touch $PHARMACISTS_FILE $MEDICINES_FILE $CUSTOMERS_FILE

# Function to print a separator
separator() {
    echo "----------------------------------------"
}

# Function to check for positive number
is_positive_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}

# Main Menu
while true; do
    separator
    echo "Pharmacy Management System"
    separator
    echo "1) Admin Panel"
    echo "2) Pharmacists Panel"
    echo "3) Customer Panel"
    echo "4) Exit"
    separator
    read -p "Enter your choice: " choice

    if [ "$choice" -eq 1 ]; then
        # Admin Panel
        while true; do
            separator
            echo "Admin Login"
            separator
            read -p "Enter admin username: " username
            read -sp "Enter admin password: " password
            echo
            if [[ "$username" == "$ADMIN_USERNAME" && "$password" == "$ADMIN_PASSWORD" ]]; then
		separator
                echo "Login successful!"
                while true; do
                    separator
                    echo "Admin Panel"
                    separator
                    echo "1) Manage Pharmacists"
                    echo "2) View Customers"
                    echo "3) Back to Main Menu"
                    separator
                    read -p "Enter your choice: " admin_choice
                    if [ "$admin_choice" -eq 1 ]; then
                        # Manage Pharmacists
                        while true; do
                            separator
                            echo "Manage Pharmacists"
                            separator
                            echo "1) Add Pharmacist"
                            echo "2) Delete Pharmacist"
                            echo "3) Update Pharmacist"
                            echo "4) View Pharmacists"
                            echo "5) Back to Admin Panel"
                            separator
                            read -p "Enter your choice: " pharmacist_choice
                            if [ "$pharmacist_choice" -eq 1 ]; then
                                while true; do
                                    read -p "Enter Pharmacist Name: " name
                                    read -p "Enter Pharmacist ID: " id
                                    if grep -q "$name:$id" $PHARMACISTS_FILE; then
                                        echo "Pharmacist already exists!"
                                    elif grep -q ":$id$" $PHARMACISTS_FILE; then
                                        echo "Pharmacist ID already exists! Please enter a unique ID."
                                    else
                                        echo "$name:$id" >> $PHARMACISTS_FILE
					separator
                                        echo "Pharmacist added successfully!"
                                        break
                                    fi
                                done
                            elif [ "$pharmacist_choice" -eq 2 ]; then
                                read -p "Enter Pharmacist ID to delete: " id
				separator
                                sed -i "/:$id$/d" $PHARMACISTS_FILE
                                echo "Pharmacist deleted successfully!"
                            elif [ "$pharmacist_choice" -eq 3 ]; then
                                read -p "Enter Pharmacist ID to update: " id
                                if grep -q ":$id$" $PHARMACISTS_FILE; then
                                    sed -i "/:$id$/d" $PHARMACISTS_FILE
                                    while true; do
                                        read -p "Enter new Pharmacist Name: " new_name
                                        read -p "Enter new Pharmacist ID: " new_id
                                        if grep -q ":$new_id$" $PHARMACISTS_FILE; then
                                            echo "Pharmacist ID already exists! Please enter a unique ID."
                                        else
                                            echo "$new_name:$new_id" >> $PHARMACISTS_FILE
                                            echo "Pharmacist updated successfully!"
                                            break
                                        fi
                                    done
                                else
                                    echo "Pharmacist ID not found!"
                                fi
                            elif [ "$pharmacist_choice" -eq 4 ]; then
                                echo "Pharmacists List:"
                                column -t -s ':' $PHARMACISTS_FILE
                            elif [ "$pharmacist_choice" -eq 5 ]; then
                                break
                            else
                                echo "Invalid choice!"
                            fi
                        done
                    elif [ "$admin_choice" -eq 2 ]; then
                        echo "Customer Transactions:"
                        column -t -s ':' $CUSTOMERS_FILE
                    elif [ "$admin_choice" -eq 3 ]; then
                        break
                    else
                        echo "Invalid choice!"
                    fi
                done
                break
            else
                echo "Invalid credentials, please try again."
            fi
        done
    elif [ "$choice" -eq 2 ]; then
        # Pharmacists Panel
        while true; do
            separator
            echo "Pharmacist Login"
            separator
            read -p "Enter pharmacist username: " username
            read -p "Enter pharmacist ID: " id
            if grep -q "$username:$id" $PHARMACISTS_FILE; then
                echo "Login successful!"
                while true; do
                    separator
                    echo "Pharmacists Panel"
                    separator
                    echo "1) Manage Medicines"
                    echo "2) Back to Main Menu"
                    separator
                    read -p "Enter your choice: " pharmacist_choice
                    if [ "$pharmacist_choice" -eq 1 ]; then
                        # Manage Medicines
                        while true; do
                            separator
                            echo "Manage Medicines"
                            separator
                            echo "1) Add Medicine"
                            echo "2) Delete Medicine"
                            echo "3) Update Medicine"
                            echo "4) View Medicines"
                            echo "5) Back to Pharmacist Panel"
                            separator
                            read -p "Enter your choice: " medicine_choice
                            if [ "$medicine_choice" -eq 1 ]; then
                                while true; do
                                    read -p "Enter Medicine Name: " name
                                    if grep -q "^$name:" $MEDICINES_FILE; then
                                        echo "Medicine already exists!"
                                    else
                                        while true; do
                                            read -p "Enter Medicine Quantity: " quantity
                                            if is_positive_number "$quantity"; then
                                                break
                                            else
                                                echo "Please enter a positive number for quantity."
                                            fi
                                        done
                                        while true; do
                                            read -p "Enter Medicine Price: " price
                                            if is_positive_number "$price"; then
                                                break
                                            else
                                                echo "Please enter a positive number for price."
                                            fi
                                        done
                                        echo "$name:$quantity:$price" >> $MEDICINES_FILE
                                        echo "Medicine added successfully!"
                                        break
                                    fi
                                done
                            elif [ "$medicine_choice" -eq 2 ]; then
                                read -p "Enter Medicine Name to delete: " name
                                sed -i "/^$name:/d" $MEDICINES_FILE
                                echo "Medicine deleted successfully!"
                            elif [ "$medicine_choice" -eq 3 ]; then
                                read -p "Enter Medicine Name to update: " name
                                if grep -q "^$name:" $MEDICINES_FILE; then
                                    sed -i "/^$name:/d" $MEDICINES_FILE
                                    while true; do
                                        read -p "Enter new Medicine Quantity: " quantity
                                        if is_positive_number "$quantity"; then
                                            break
                                        else
                                            echo "Please enter a positive number for quantity."
                                        fi
                                    done
                                    while true; do
                                        read -p "Enter new Medicine Price: " price
                                        if is_positive_number "$price"; then
                                            break
                                        else
                                            echo "Please enter a positive number for price."
                                        fi
                                    done
                                    echo "$name:$quantity:$price" >> $MEDICINES_FILE
                                    echo "Medicine updated successfully!"
                                else
                                    echo "Medicine not found!"
                                fi
                            elif [ "$medicine_choice" -eq 4 ]; then
                                echo "Medicines List:"
                                column -t -s ':' $MEDICINES_FILE
                            elif [ "$medicine_choice" -eq 5 ]; then
                                break
                            else
                                echo "Invalid choice!"
                            fi
                        done
                    elif [ "$pharmacist_choice" -eq 2 ]; then
                        break
                    else
                        echo "Invalid choice!"
                    fi
                done
                break
            else
                echo "Invalid credentials, please try again."
            fi
        done
            elif [ "$choice" -eq 3 ]; then
        # Customer Panel
        separator
        echo "Customer Panel"
        separator
        echo "Available Medicines:"
        column -t -s ':' $MEDICINES_FILE

        read -p "How many medicines do you want to buy? Enter a number: " num_medicines
        total_bill=0

        for (( i=1; i<=$num_medicines; i++ )); do
            while true; do
                read -p "Enter medicine name $i: " med_name
                if grep -q "^$med_name:" $MEDICINES_FILE; then
                    available_quantity=$(grep "^$med_name:" $MEDICINES_FILE | cut -d ':' -f 2)
                    while true; do
                        read -p "Enter quantity for $med_name (available: $available_quantity): " med_quantity
                        if is_positive_number "$med_quantity" && [ "$med_quantity" -le "$available_quantity" ]; then
                            break
                        else
                            echo "Invalid quantity or not enough available. Please enter a valid quantity."
                        fi
                    done

                    med_data=$(grep "^$med_name:" $MEDICINES_FILE)
                    med_price=$(echo $med_data | cut -d ':' -f 3)
                    total=$((med_quantity * med_price))
                    total_bill=$((total_bill + total))

                    updated_quantity=$((available_quantity - med_quantity))

                    # Update the medicine file with the new quantity
                    sed -i "s/^$med_name:$available_quantity:$med_price$/$med_name:$updated_quantity:$med_price/" $MEDICINES_FILE

                    echo "$med_name:$med_quantity:$total" >> $CUSTOMERS_FILE
                    echo "Medicine added successfully!"
                    break
                else
                    echo "Medicine not found, please enter a valid medicine name."
                fi
            done
        done

        echo "Total bill: $total_bill"
        echo "Bill receipt generated!"

        while true; do
            read -p "Do you want to go back to the main menu? (yes/no): " back_to_menu
            if [[ "$back_to_menu" != "yes" ]]; then
                break
            fi
        done
    elif [ "$choice" -eq 4 ]; then
        echo "Thank you for visiting!"
        break
    else
        echo "Invalid choice!"
    fi
done
