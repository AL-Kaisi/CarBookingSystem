// Main JavaScript file for Car Booking System

// Auto-hide alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.display = 'none';
        }, 5000);
    });
});

// Date validation for booking forms
function validateBookingDates() {
    const fromDate = document.getElementById('date_from');
    const toDate = document.getElementById('date_to');
    
    if (fromDate && toDate) {
        fromDate.addEventListener('change', function() {
            toDate.min = this.value;
            if (toDate.value && toDate.value < this.value) {
                toDate.value = this.value;
            }
        });
        
        toDate.addEventListener('change', function() {
            if (this.value < fromDate.value) {
                this.value = fromDate.value;
            }
        });
        
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        fromDate.min = today;
        toDate.min = today;
    }
}

// Initialize date validation
if (document.getElementById('bookingForm')) {
    validateBookingDates();
}

// Form confirmation
function confirmAction(message) {
    return confirm(message || 'Are you sure you want to perform this action?');
}

// Add confirmation to status changes
document.querySelectorAll('select[name="status"]').forEach(select => {
    select.addEventListener('change', function(e) {
        if (!confirmAction('Are you sure you want to change the booking status?')) {
            e.preventDefault();
            this.value = '';
        }
    });
});

// Search form enhancement
const searchForm = document.querySelector('.search-form');
if (searchForm) {
    const searchInput = searchForm.querySelector('input[name="query"]');
    if (searchInput) {
        searchInput.addEventListener('keyup', function(e) {
            if (e.key === 'Escape') {
                this.value = '';
            }
        });
    }
}

// Table row click handler
document.querySelectorAll('.table tbody tr').forEach(row => {
    const link = row.querySelector('a');
    if (link) {
        row.style.cursor = 'pointer';
        row.addEventListener('click', function(e) {
            if (e.target.tagName !== 'A' && e.target.tagName !== 'BUTTON' && e.target.tagName !== 'SELECT') {
                window.location = link.href;
            }
        });
    }
});

// Format currency inputs
document.querySelectorAll('input[name="daily_hire_rate"]').forEach(input => {
    input.addEventListener('blur', function() {
        const value = parseFloat(this.value);
        if (!isNaN(value)) {
            this.value = value.toFixed(2);
        }
    });
});

// Print functionality
function printReport() {
    window.print();
}

// Export to CSV functionality
function exportTableToCSV(tableId, filename) {
    const table = document.getElementById(tableId);
    if (!table) return;
    
    let csv = [];
    const rows = table.querySelectorAll('tr');
    
    rows.forEach(row => {
        const cells = row.querySelectorAll('td, th');
        const rowData = Array.from(cells).map(cell => {
            let text = cell.textContent.trim();
            // Escape quotes in CSV
            if (text.includes(',') || text.includes('"')) {
                text = '"' + text.replace(/"/g, '""') + '"';
            }
            return text;
        });
        csv.push(rowData.join(','));
    });
    
    // Create and download file
    const csvContent = csv.join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = filename || 'export.csv';
    a.click();
}

// Add export buttons to tables
document.addEventListener('DOMContentLoaded', function() {
    const tables = document.querySelectorAll('.table');
    tables.forEach((table, index) => {
        if (!table.id) {
            table.id = 'table-' + index;
        }
        
        const exportBtn = document.createElement('button');
        exportBtn.textContent = 'Export to CSV';
        exportBtn.className = 'btn btn-secondary btn-sm';
        exportBtn.style.marginBottom = '10px';
        exportBtn.onclick = () => exportTableToCSV(table.id, 'report.csv');
        
        table.parentNode.insertBefore(exportBtn, table);
    });
});