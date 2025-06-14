import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { EmployeeService, Employee } from '../employee.service';

@Component({
  selector: 'app-employee',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './employee.component.html',
  styleUrls: ['./employee.component.css']
})
export class EmployeeComponent {
  positions: string[] = [
    'Janitor',
    'Office Assistant',
    'Intern',
    'Junior Software Developer',
    'Software Developer',
    'Senior Software Developer',
    'Lead Developer',
    'QA Engineer',
    'DevOps Engineer',
    'UI/UX Designer',
    'Product Manager',
    'Project Manager',
    'HR Manager',
    'IT Manager',
    'Director of Engineering',
    'VP of Engineering',
    'CTO',
    'COO',
    'CFO',
    'CEO'
  ];

  name = '';
  surname = '';
  salary: number | null = null;
  position: string = this.positions[0];

  employees: Employee[] = [];

  constructor(private employeeService: EmployeeService) {}

  ngOnInit() {
    this.loadEmployees();
  }

  loadEmployees() {
    this.employeeService.getEmployees().subscribe(data => this.employees = data);
  }

  addEmployee() {
    if (this.name && this.surname && this.salary !== null && this.position) {
      this.employeeService.addEmployee({
        name: this.name,
        surname: this.surname,
        salary: this.salary,
        position: this.position
      }).subscribe(() => {
        this.name = '';
        this.surname = '';
        this.salary = null;
        this.position = this.positions[0];
        this.loadEmployees();
      });
    }
  }

  deleteEmployee(id: string) {
    this.employeeService.deleteEmployee(id).subscribe(() => this.loadEmployees());
  }
}
